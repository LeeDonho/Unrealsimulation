classdef RealFinal_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        Accelerationms2Gauge           matlab.ui.control.Gauge
        Accelerationms2GaugeLabel      matlab.ui.control.Label
        VelocitymsGauge                matlab.ui.control.Gauge
        VelocitymsGaugeLabel           matlab.ui.control.Label
        Label_3                        matlab.ui.control.Label
        Label_2                        matlab.ui.control.Label
        Label                          matlab.ui.control.Label
        Decelerationms2Spinner         matlab.ui.control.Spinner
        Accelerationms2SpinnerLabel_2  matlab.ui.control.Label
        Decelerationms2SpinnerLabel    matlab.ui.control.Label
        ndEgoVelocitykmhSpinner        matlab.ui.control.Spinner
        ndEgoVelocitykmhSpinnerLabel   matlab.ui.control.Label
        ndAccelerationms2Spinner       matlab.ui.control.Spinner
        MaintaintimesSpinnerLabel      matlab.ui.control.Label
        RoadModelLabel                 matlab.ui.control.Label
        VehicleModelLabel              matlab.ui.control.Label
        SenarioModelLabel              matlab.ui.control.Label
        MaintaintimesSpinner           matlab.ui.control.Spinner
        RoadLanemSpinner               matlab.ui.control.Spinner
        RoadLanemSpinnerLabel          matlab.ui.control.Label
        RoadLengthmSpinner             matlab.ui.control.Spinner
        RoadLengthmSpinnerLabel        matlab.ui.control.Label
        RoadWidthmSpinner              matlab.ui.control.Spinner
        RoadWidthmSpinnerLabel         matlab.ui.control.Label
        VehicleHeightmSpinner          matlab.ui.control.Spinner
        VehicleHeightmSpinnerLabel     matlab.ui.control.Label
        VehicleLengthmSpinner          matlab.ui.control.Spinner
        VehicleLengthmSpinnerLabel     matlab.ui.control.Label
        VehicleWidthmSpinner           matlab.ui.control.Spinner
        VehicleWidthmSpinnerLabel      matlab.ui.control.Label
        stAccelerationms2Spinner       matlab.ui.control.Spinner
        stAccelerationms2SpinnerLabel  matlab.ui.control.Label
        stEgoVelocitykmhSpinner        matlab.ui.control.Spinner
        stEgoVelocitykmhSpinnerLabel   matlab.ui.control.Label
        StartButton                    matlab.ui.control.Button
        YZaxis                         matlab.ui.control.UIAxes
        XYaxis                         matlab.ui.control.UIAxes
        Distancegraph                  matlab.ui.control.UIAxes
        Accelerationgraph              matlab.ui.control.UIAxes
        Velocitygraph                  matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        vel_list =[]
        dist_list =[]
        accel_list =[]
        
        x_cg
        y_cg
        
        
        vel
        stego_acc
        stego_vel
        ndego_acc
        ndego_vel
        dec_acc
        maintaintime
        linechange_vel
        
        road_w
        road_l
        road_Lane
        car_w
        car_h
        car_l
        
        x_car
        z_car
        y_car
        yx_car
        y_carchange1
        yx_carchange1
        y_carchange2
        yx_carchange2
        
       
        cons_t1
        cons_t2
        cons_t3
        cons_t4
        a
        v
        
        
        
        % Description
    end
        

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            %Parameters
            
            s=0.; %delay constant 스피너 값 받아오기
            app.stego_acc=app.stAccelerationms2Spinner.Value;
            app.stego_vel=app.stEgoVelocitykmhSpinner.Value/3.6;
            
            app.ndego_acc=app.ndAccelerationms2Spinner.Value;
            app.ndego_vel=app.ndEgoVelocitykmhSpinner.Value/3.6;
            
            app.dec_acc=app.Decelerationms2Spinner.Value;
            app.maintaintime=app.MaintaintimesSpinner.Value;
            
            app.linechange_vel=1;
            timegap=0.5;
            
            
            app.road_w=app.RoadWidthmSpinner.Value;
            app.road_l=app.RoadLengthmSpinner.Value;
            app.road_Lane=app.RoadLanemSpinner.Value;
            
            app.car_w=app.VehicleWidthmSpinner.Value;
            app.car_h=app.VehicleHeightmSpinner.Value;
            app.car_l=app.VehicleLengthmSpinner.Value;
            
            %애니메이션
            app.x_car = [0 0 app.car_l app.car_l];
            app.z_car = [0 app.car_h app.car_h 0];
            
            location_y= (app.road_Lane-1)*app.road_w+(app.road_w-app.car_w)/2;
            %에니메이션 아래
            app.y_car = [location_y location_y location_y+app.car_w location_y+app.car_w];
            %애니메이션 위
            app.yx_car = [location_y+app.car_w location_y location_y location_y+app.car_w];
            
            
            
            %사각형과 삼각형을 나누어서 연산 / 등속도가 되는 지점을 구한다.
            app.cons_t1=app.stego_vel/app.stego_acc;
            app.cons_t2=app.stego_vel/app.dec_acc;
            app.cons_t3=app.ndego_vel/app.ndego_acc;
            app.cons_t4=app.road_w/app.linechange_vel;
            
            
            
%            plot(app.XYaxis, app.x_car, app.z_car);
%            y=0;
%            plot(app.XYaxis, y,'-',"Color",'b')
            
            
            time_length=100;
            for t1=0:timegap:app.cons_t1+app.maintaintime
                pause(timegap);
                app.vel=app.stego_acc*t1;
%                app.a=app.stego_acc*ones(1,time_length);
                app.a=app.stego_acc;
                app.v=app.a.*t1;
                ego_v=app.stego_vel;
                
                if app.vel<=app.stego_vel
                    distance=1/2*app.v.*t1;
                    x_car1=app.vel*t1/2;
                    app.x_car = [x_car1 x_car1 x_car1+app.car_l x_car1+app.car_l];
                    
                    plot(app.Velocitygraph,t1,app.v,'-*',"Color",'r');
                    plot(app.Accelerationgraph,t1,app.a,'-*','Color','g');
                    plot(app.Distancegraph,t1,distance,'-*','Color','m');
                    
                    
                    
                    app.x_cg = mean(app.x_car);
                    app.y_cg = mean(app.yx_car);
                    
                    
                    plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                    
                    %plot(app.XYaxis, app.x_car, app.yx_car);
                    plot(app.YZaxis, app.y_car,app.z_car);
                    app.Accelerationms2Gauge.Value=app.stego_acc;
                    app.VelocitymsGauge.Value=app.vel;
                    
                    hold(app.Velocitygraph, "on");
                    hold(app.Accelerationgraph, "on");
                    hold(app.Distancegraph, "on");
                    hold(app.XYaxis, "on");
                 
               

                else 
                    distance=app.stego_vel*app.cons_t1/2+app.stego_vel*(t1-app.cons_t1);
                    x_car1=app.stego_vel*app.cons_t1/2+app.stego_vel*(t1-app.cons_t1);
                    app.x_car = [x_car1 x_car1 x_car1+app.car_l x_car1+app.car_l];
                                        
                    plot(app.Velocitygraph,t1,ego_v,'-*',"Color",'r');
                    plot(app.Accelerationgraph,t1,zeros,'-*','Color','g');
                    plot(app.Distancegraph,t1,distance,'-*','Color','m');
                    
                    app.x_cg = mean(app.x_car);
                    app.y_cg = mean(app.yx_car);
                    plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                    
                    %plot(app.XYaxis, app.x_car, app.yx_car);
                    plot(app.YZaxis, app.y_car,app.z_car);
                    app.Accelerationms2Gauge.Value=0;
                    app.VelocitymsGauge.Value=app.stego_vel;
                    
                    hold(app.XYaxis, "on");
                    hold(app.Velocitygraph, "on");
                    hold(app.Accelerationgraph, "on");
                    hold(app.Distancegraph, "on");
                 
                end
                t1_end=app.cons_t1+app.maintaintime;
                x_car1=app.stego_vel*app.cons_t1/2+app.stego_vel*app.maintaintime;
                    
            end
            
            %감속 후 정지
            vel2 = app.stego_vel;
            for t2_1=timegap:timegap:app.cons_t2+app.maintaintime
              if vel2 > 0   
                
                
                t2_2=t2_1+t1_end;
                pause(timegap);
                vel2=app.stego_vel-app.dec_acc*t2_1;

%                app.a=-1*app.dec_acc*ones(1,time_length);
%                app.v=app.stego_vel+app.a.*t2_1;
                app.a=-1*app.dec_acc;
                app.v=app.stego_vel+app.a.*t2_1;    
                x_car2=x_car1+(app.stego_vel+vel2)*t2_1/2;
                
                app.x_car=[x_car2 x_car2 x_car2+app.car_l x_car2+app.car_l];
                
                plot(app.Velocitygraph,t2_2,app.v,'-*',"Color",'r');
                plot(app.Accelerationgraph,t2_2,app.a,'-*','Color','g');
                plot(app.Distancegraph,t2_2,x_car2,'-*','Color','m');
                
                app.x_cg = mean(app.x_car);
                app.y_cg = mean(app.yx_car);
                plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
            
                %plot(app.XYaxis, app.x_car, app.yx_car);
                plot(app.YZaxis, app.y_car, app.z_car);
                app.Accelerationms2Gauge.Value=-1*app.dec_acc;
                app.VelocitymsGauge.Value=vel2;
                
                
                
                hold(app.Velocitygraph, "on");
                hold(app.Accelerationgraph, "on");
                hold(app.Distancegraph, "on");
                hold(app.XYaxis, "on");
                
             
              else
                    t2_2=t2_1+t1_end;
                    pause(timegap);
                    app.a=0;
                    app.v=0;
                    x_car2=x_car1+app.stego_vel*app.cons_t2/2;
                    app.x_car=[x_car2 x_car2 x_car2+app.car_l x_car2+app.car_l];
                    plot(app.Velocitygraph,t2_2,app.v,'-*',"Color",'r');
                    plot(app.Accelerationgraph,t2_2,app.a,'-*','Color','g');
                    plot(app.Distancegraph,t2_2,x_car2,'-*','Color','m');
                    
                    app.x_cg = mean(app.x_car);
                    app.y_cg = mean(app.yx_car);
                    plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                    
%                    plot(app.XYaxis, app.x_car, app.yx_car);    
                    plot(app.YZaxis, app.y_car, app.z_car);
                    app.Accelerationms2Gauge.Value=0;
                    app.VelocitymsGauge.Value=0;
                    
               
                    hold(app.XYaxis, "on");
                    hold(app.Velocitygraph, "on");
                    hold(app.Accelerationgraph, "on");
                    hold(app.Distancegraph, "on");
                 
               end
            end
                t2_end=t1_end+app.cons_t2 + app.maintaintime;
      
                
                vel3 = app.ndego_acc;
                
                %가속
                for t3_1=timegap:timegap:app.cons_t3+app.maintaintime
                   
                    
                         if vel3 < app.ndego_vel
                            
                            t3_2=t3_1+t2_end;
                                                      
                            
                            pause(timegap);
                            vel3=app.ndego_acc*t3_1;
                            app.a=app.ndego_acc;
                            app.v=app.a.*t3_1;
                            
                            
                            x_car3=x_car2+vel3*t3_1/2;
                            app.x_car=[x_car3 x_car3 x_car3+app.car_l x_car3+app.car_l];
                         
                            plot(app.Velocitygraph,t3_2,app.v,'-*',"Color",'r');
                            plot(app.Accelerationgraph,t3_2,app.a,'-*','Color','g');
                            plot(app.Distancegraph,t3_2,x_car3,'-*','Color','m');
                            
                            app.x_cg = mean(app.x_car);
                            app.y_cg = mean(app.yx_car);
                            plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');                           
                                    
                            
%                            plot(app.XYaxis, app.x_car, app.yx_car);
                            plot(app.YZaxis, app.y_car, app.z_car);
                            app.Accelerationms2Gauge.Value=app.ndego_acc;
                            app.VelocitymsGauge.Value=vel3;
                            
                            
                            hold(app.Velocitygraph, "on");
                            hold(app.Accelerationgraph, "on");
                            hold(app.Distancegraph, "on");
                            hold(app.XYaxis, "on");
                            
                        else
                            
                            t3_2=t3_1+t2_end;
                            pause(timegap);
                        
                            app.a=zeros(1,time_length);
                            app.v=app.ndego_vel*ones(1,time_length);
                            x_car3=x_car2+app.ndego_vel*app.cons_t3/2+app.ndego_vel*(t3_1-app.cons_t3);
                            app.x_car=[x_car3 x_car3 x_car3+app.car_l x_car3+app.car_l];
                            plot(app.Velocitygraph,t3_2,app.v,'-*',"Color",'r');
                            plot(app.Accelerationgraph,t3_2,app.a,'-*','Color','g');
                            plot(app.Distancegraph,t3_2,x_car3,'-*','Color','m');
                            
                            app.x_cg = mean(app.x_car);
                            app.y_cg = mean(app.yx_car);
                            plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                            
 %                           plot(app.XYaxis, app.x_car, app.yx_car);
                            plot(app.YZaxis, app.y_car, app.z_car);
                            app.Accelerationms2Gauge.Value=0;
                            app.VelocitymsGauge.Value=app.ndego_vel;
                            
                            
                            hold(app.Velocitygraph, "on");
                            hold(app.Accelerationgraph, "on");
                            hold(app.Distancegraph, "on");
                            hold(app.XYaxis, "on");
                            
                    end
                        
                    
                end
                t3_end=t2_end+app.cons_t3+app.maintaintime;
                x_car3=x_car2+app.ndego_vel*app.cons_t3/2+app.ndego_vel*app.maintaintime;
                
                app.a=zeros(1,time_length);
                app.v=app.ndego_vel*ones(1,time_length); 
                
                %차선 변경
               for t4_1=timegap:timegap:app.cons_t4+app.maintaintime
                   t4_2=t4_1+t3_end;
                   pause(timegap);
                   
                   
                  if app.linechange_vel*t4_1 < app.road_w

                       
                       x_car4=x_car3+app.ndego_vel*t4_1;
                       app.x_car=[x_car4 x_car4 x_car4+app.car_l x_car4+app.car_l];
                       app.y_carchange1=app.y_car-app.linechange_vel*t4_1;
                       app.yx_carchange1=app.yx_car-app.linechange_vel*t4_1;
                       
                       plot(app.Velocitygraph,t4_2,app.v,'-*',"Color",'r')                       
                       plot(app.Accelerationgraph,t4_2,app.a,'-*','Color','g');
                       plot(app.Distancegraph,t4_2,x_car4,'-*','Color','m');
                       
                       
                       app.x_cg = mean(x_car4);
                       app.y_cg = mean(app.yx_carchange1);
                       plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                       
      %                 plot(app.XYaxis, app.x_car, app.yx_carchange1);
                       plot(app.YZaxis, app.y_carchange1, app.z_car);
                       
                       
                        hold(app.Velocitygraph, "on");
                        hold(app.Accelerationgraph, "on");
                        hold(app.Distancegraph, "on");
                        hold(app.XYaxis, "on");
                 
                   
                  else 
                       x_car4=x_car3+app.ndego_vel*t4_1;
                       
                       plot(app.Velocitygraph,t4_2,app.v,'-*',"Color",'r')                       
                       plot(app.Accelerationgraph,t4_2,app.a,'-*','Color','g');
                       plot(app.Distancegraph,t4_2,x_car4,'-*','Color','m');
                       
                      
                       app.y_carchange1=app.y_car-app.road_w;
                       app.yx_carchange1=app.yx_car-app.road_w;
                       plot(app.YZaxis, app.y_carchange1, app.z_car);
                      % plot(app.XYaxis, app.x_car, app.yx_carchange1);
                       
                       app.x_cg = mean(x_car4);
                       app.y_cg = mean(app.yx_carchange1);
                       plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                       
                        hold(app.Velocitygraph, "on");
                        hold(app.Accelerationgraph, "on");
                        hold(app.Distancegraph, "on");
                        hold(app.XYaxis, "on");
                 
                       
                       
                       
                   end
               end
               %차선 복귀
               t4_end=t3_end+app.cons_t4+app.maintaintime;
               x_car4=x_car3+app.ndego_vel*(app.cons_t4+app.maintaintime);
               
               for t5_1=0:timegap:app.cons_t4+app.maintaintime
                   
                   t5_2=t5_1+t4_end;
                   pause(timegap);
                   
                   if app.linechange_vel*t5_1 < app.road_w                   
                       
                       
                       x_car5=x_car4+app.ndego_vel*t5_1;
                       app.x_car=[x_car5 x_car5 x_car5+app.car_l x_car5+app.car_l];
                       app.y_carchange2=app.y_carchange1+app.linechange_vel*t5_1;
                       app.yx_carchange2=app.yx_carchange1+app.linechange_vel*t5_1;
                       
                       app.x_cg = mean(x_car5);
                       app.y_cg = mean(app.yx_carchange2);
                       plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                       
                       plot(app.Velocitygraph,t5_2,app.v,'-*',"Color",'r');
                       plot(app.Accelerationgraph,t5_2,app.a,'-*','Color','g');
                       plot(app.Distancegraph,t5_2,x_car5,'-*','Color','m');
    %                   plot(app.XYaxis, app.x_car, app.yx_carchange2);
                       
    
                       plot(app.YZaxis, app.y_carchange2, app.z_car);
                            
                       disp(app.x_cg);
                       disp(app.y_cg);
                       
                       
                        hold(app.Velocitygraph, "on");
                        hold(app.Accelerationgraph, "on");
                        hold(app.Distancegraph, "on");
                        hold(app.XYaxis, "on");
                   else
                       
                       x_car5=x_car4+app.ndego_vel*t5_1;
                       
                       plot(app.Velocitygraph,t4_2,app.v,'-*',"Color",'r')                       
                       plot(app.Accelerationgraph,t4_2,app.a,'-*','Color','g');
                       plot(app.Distancegraph,t4_2,x_car4,'-*','Color','m');
                       
                       
                       
                       app.y_carchange2=app.y_car;
                       plot(app.YZaxis, app.y_carchange2, app.z_car);
                       app.yx_carchange2=app.yx_car;
                       %plot(app.XYaxis,app.x_car, app.yx_carchange2);
                       
                       app.x_cg = mean(x_car5);
                       app.y_cg = mean(app.yx_carchange2);
                       plot(app.XYaxis, app.x_cg, app.y_cg, '-*', "Color",'b');
                       
                       hold(app.Velocitygraph, "on");
                       hold(app.Accelerationgraph, "on");
                       hold(app.Distancegraph, "on");
                       hold(app.XYaxis, "on");                       
                       
                       
                       
                       
                   end
                   
               end
            

     
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1532 704];
            app.UIFigure.Name = 'MATLAB App';

            % Create Velocitygraph
            app.Velocitygraph = uiaxes(app.UIFigure);
            title(app.Velocitygraph, 'Velocity(m/s)')
            xlabel(app.Velocitygraph, 'Time sec')
            ylabel(app.Velocitygraph, 'm/s')
            zlabel(app.Velocitygraph, 'Z')
            app.Velocitygraph.XLim = [0 50];
            app.Velocitygraph.YLim = [0 50];
            app.Velocitygraph.Position = [329 459 300 196];

            % Create Accelerationgraph
            app.Accelerationgraph = uiaxes(app.UIFigure);
            title(app.Accelerationgraph, 'Acceleration(m/s^2)')
            xlabel(app.Accelerationgraph, 'Time sec')
            ylabel(app.Accelerationgraph, 'm/s^2')
            zlabel(app.Accelerationgraph, 'Z')
            app.Accelerationgraph.XLim = [0 50];
            app.Accelerationgraph.YLim = [-10 10];
            app.Accelerationgraph.Position = [329 257 300 200];

            % Create Distancegraph
            app.Distancegraph = uiaxes(app.UIFigure);
            title(app.Distancegraph, 'Distance(m)')
            xlabel(app.Distancegraph, 'Time sec')
            ylabel(app.Distancegraph, 'meter')
            zlabel(app.Distancegraph, 'Z')
            app.Distancegraph.XLim = [0 50];
            app.Distancegraph.YLim = [0 500];
            app.Distancegraph.Position = [309 31 320 206];

            % Create XYaxis
            app.XYaxis = uiaxes(app.UIFigure);
            title(app.XYaxis, 'X-Y axis')
            xlabel(app.XYaxis, 'X')
            ylabel(app.XYaxis, 'Y')
            zlabel(app.XYaxis, 'Z')
            app.XYaxis.XLim = [0 500];
            app.XYaxis.YLim = [-8 8];
            app.XYaxis.XAxisLocation = 'origin';
            app.XYaxis.Position = [857 357 600 310];

            % Create YZaxis
            app.YZaxis = uiaxes(app.UIFigure);
            title(app.YZaxis, 'Y-Z axis')
            xlabel(app.YZaxis, 'Y')
            ylabel(app.YZaxis, 'Z')
            zlabel(app.YZaxis, 'Z')
            app.YZaxis.XLim = [-10 10];
            app.YZaxis.YLim = [0 8];
            app.YZaxis.YAxisLocation = 'origin';
            app.YZaxis.Position = [879 31 578 315];

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [57 48 223 22];
            app.StartButton.Text = 'Start';

            % Create stEgoVelocitykmhSpinnerLabel
            app.stEgoVelocitykmhSpinnerLabel = uilabel(app.UIFigure);
            app.stEgoVelocitykmhSpinnerLabel.HorizontalAlignment = 'right';
            app.stEgoVelocitykmhSpinnerLabel.Position = [45 543 125 22];
            app.stEgoVelocitykmhSpinnerLabel.Text = '1st Ego Velocity(km/h)';

            % Create stEgoVelocitykmhSpinner
            app.stEgoVelocitykmhSpinner = uispinner(app.UIFigure);
            app.stEgoVelocitykmhSpinner.Position = [185 543 100 22];
            app.stEgoVelocitykmhSpinner.Value = 60;

            % Create stAccelerationms2SpinnerLabel
            app.stAccelerationms2SpinnerLabel = uilabel(app.UIFigure);
            app.stAccelerationms2SpinnerLabel.HorizontalAlignment = 'right';
            app.stAccelerationms2SpinnerLabel.Position = [40 512 130 22];
            app.stAccelerationms2SpinnerLabel.Text = '1st Acceleration(m/s^2)';

            % Create stAccelerationms2Spinner
            app.stAccelerationms2Spinner = uispinner(app.UIFigure);
            app.stAccelerationms2Spinner.Position = [185 512 100 22];
            app.stAccelerationms2Spinner.Value = 3;

            % Create VehicleWidthmSpinnerLabel
            app.VehicleWidthmSpinnerLabel = uilabel(app.UIFigure);
            app.VehicleWidthmSpinnerLabel.HorizontalAlignment = 'right';
            app.VehicleWidthmSpinnerLabel.Position = [69 284 96 22];
            app.VehicleWidthmSpinnerLabel.Text = 'Vehicle Width(m)';

            % Create VehicleWidthmSpinner
            app.VehicleWidthmSpinner = uispinner(app.UIFigure);
            app.VehicleWidthmSpinner.Position = [180 284 100 22];
            app.VehicleWidthmSpinner.Value = 1.5;

            % Create VehicleLengthmSpinnerLabel
            app.VehicleLengthmSpinnerLabel = uilabel(app.UIFigure);
            app.VehicleLengthmSpinnerLabel.HorizontalAlignment = 'right';
            app.VehicleLengthmSpinnerLabel.Position = [63 252 102 22];
            app.VehicleLengthmSpinnerLabel.Text = 'Vehicle Length(m)';

            % Create VehicleLengthmSpinner
            app.VehicleLengthmSpinner = uispinner(app.UIFigure);
            app.VehicleLengthmSpinner.Position = [180 252 100 22];
            app.VehicleLengthmSpinner.Value = 3.1;

            % Create VehicleHeightmSpinnerLabel
            app.VehicleHeightmSpinnerLabel = uilabel(app.UIFigure);
            app.VehicleHeightmSpinnerLabel.HorizontalAlignment = 'right';
            app.VehicleHeightmSpinnerLabel.Position = [65 221 100 22];
            app.VehicleHeightmSpinnerLabel.Text = 'Vehicle Height(m)';

            % Create VehicleHeightmSpinner
            app.VehicleHeightmSpinner = uispinner(app.UIFigure);
            app.VehicleHeightmSpinner.Position = [180 221 100 22];
            app.VehicleHeightmSpinner.Value = 1.4;

            % Create RoadWidthmSpinnerLabel
            app.RoadWidthmSpinnerLabel = uilabel(app.UIFigure);
            app.RoadWidthmSpinnerLabel.HorizontalAlignment = 'right';
            app.RoadWidthmSpinnerLabel.Position = [79 148 86 22];
            app.RoadWidthmSpinnerLabel.Text = 'Road Width(m)';

            % Create RoadWidthmSpinner
            app.RoadWidthmSpinner = uispinner(app.UIFigure);
            app.RoadWidthmSpinner.Position = [180 148 100 22];
            app.RoadWidthmSpinner.Value = 2;

            % Create RoadLengthmSpinnerLabel
            app.RoadLengthmSpinnerLabel = uilabel(app.UIFigure);
            app.RoadLengthmSpinnerLabel.HorizontalAlignment = 'right';
            app.RoadLengthmSpinnerLabel.Position = [73 117 92 22];
            app.RoadLengthmSpinnerLabel.Text = 'Road Length(m)';

            % Create RoadLengthmSpinner
            app.RoadLengthmSpinner = uispinner(app.UIFigure);
            app.RoadLengthmSpinner.Position = [180 117 100 22];
            app.RoadLengthmSpinner.Value = 500;

            % Create RoadLanemSpinnerLabel
            app.RoadLanemSpinnerLabel = uilabel(app.UIFigure);
            app.RoadLanemSpinnerLabel.HorizontalAlignment = 'right';
            app.RoadLanemSpinnerLabel.Position = [83 88 82 22];
            app.RoadLanemSpinnerLabel.Text = 'Road Lane(m)';

            % Create RoadLanemSpinner
            app.RoadLanemSpinner = uispinner(app.UIFigure);
            app.RoadLanemSpinner.Position = [180 88 100 22];
            app.RoadLanemSpinner.Value = 3;

            % Create MaintaintimesSpinner
            app.MaintaintimesSpinner = uispinner(app.UIFigure);
            app.MaintaintimesSpinner.Position = [185 600 100 22];
            app.MaintaintimesSpinner.Value = 3;

            % Create SenarioModelLabel
            app.SenarioModelLabel = uilabel(app.UIFigure);
            app.SenarioModelLabel.FontSize = 17;
            app.SenarioModelLabel.FontWeight = 'bold';
            app.SenarioModelLabel.Position = [25 639 122 22];
            app.SenarioModelLabel.Text = 'Senario Model';

            % Create VehicleModelLabel
            app.VehicleModelLabel = uilabel(app.UIFigure);
            app.VehicleModelLabel.FontSize = 17;
            app.VehicleModelLabel.FontWeight = 'bold';
            app.VehicleModelLabel.Position = [25 324 118 22];
            app.VehicleModelLabel.Text = 'Vehicle Model';

            % Create RoadModelLabel
            app.RoadModelLabel = uilabel(app.UIFigure);
            app.RoadModelLabel.FontSize = 17;
            app.RoadModelLabel.FontWeight = 'bold';
            app.RoadModelLabel.Position = [59 180 102 22];
            app.RoadModelLabel.Text = 'Road Model';

            % Create MaintaintimesSpinnerLabel
            app.MaintaintimesSpinnerLabel = uilabel(app.UIFigure);
            app.MaintaintimesSpinnerLabel.HorizontalAlignment = 'right';
            app.MaintaintimesSpinnerLabel.Position = [79 600 91 22];
            app.MaintaintimesSpinnerLabel.Text = 'Maintain time(s)';

            % Create ndAccelerationms2Spinner
            app.ndAccelerationms2Spinner = uispinner(app.UIFigure);
            app.ndAccelerationms2Spinner.Position = [184 369 100 22];
            app.ndAccelerationms2Spinner.Value = 3;

            % Create ndEgoVelocitykmhSpinnerLabel
            app.ndEgoVelocitykmhSpinnerLabel = uilabel(app.UIFigure);
            app.ndEgoVelocitykmhSpinnerLabel.HorizontalAlignment = 'right';
            app.ndEgoVelocitykmhSpinnerLabel.Position = [40 400 129 22];
            app.ndEgoVelocitykmhSpinnerLabel.Text = '2nd Ego Velocity(km/h)';

            % Create ndEgoVelocitykmhSpinner
            app.ndEgoVelocitykmhSpinner = uispinner(app.UIFigure);
            app.ndEgoVelocitykmhSpinner.Position = [184 400 100 22];
            app.ndEgoVelocitykmhSpinner.Value = 50;

            % Create Decelerationms2SpinnerLabel
            app.Decelerationms2SpinnerLabel = uilabel(app.UIFigure);
            app.Decelerationms2SpinnerLabel.HorizontalAlignment = 'right';
            app.Decelerationms2SpinnerLabel.Position = [58 454 112 22];
            app.Decelerationms2SpinnerLabel.Text = 'Deceleration(m/s^2)';

            % Create Accelerationms2SpinnerLabel_2
            app.Accelerationms2SpinnerLabel_2 = uilabel(app.UIFigure);
            app.Accelerationms2SpinnerLabel_2.HorizontalAlignment = 'right';
            app.Accelerationms2SpinnerLabel_2.Position = [35 369 134 22];
            app.Accelerationms2SpinnerLabel_2.Text = '2nd Acceleration(m/s^2)';

            % Create Decelerationms2Spinner
            app.Decelerationms2Spinner = uispinner(app.UIFigure);
            app.Decelerationms2Spinner.Position = [185 454 100 22];
            app.Decelerationms2Spinner.Value = 2;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontWeight = 'bold';
            app.Label.Position = [52 564 65 25];
            app.Label.Text = '1. 1차 가속';

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [52 481 65 25];
            app.Label_2.Text = '2. 감속';

            % Create Label_3
            app.Label_3 = uilabel(app.UIFigure);
            app.Label_3.FontWeight = 'bold';
            app.Label_3.Position = [52 425 65 25];
            app.Label_3.Text = '3. 2차 가속';

            % Create VelocitymsGaugeLabel
            app.VelocitymsGaugeLabel = uilabel(app.UIFigure);
            app.VelocitymsGaugeLabel.HorizontalAlignment = 'center';
            app.VelocitymsGaugeLabel.Position = [690 485 74 22];
            app.VelocitymsGaugeLabel.Text = 'Velocity(m/s)';

            % Create VelocitymsGauge
            app.VelocitymsGauge = uigauge(app.UIFigure, 'circular');
            app.VelocitymsGauge.Limits = [0 40];
            app.VelocitymsGauge.Position = [665 522 120 120];

            % Create Accelerationms2GaugeLabel
            app.Accelerationms2GaugeLabel = uilabel(app.UIFigure);
            app.Accelerationms2GaugeLabel.HorizontalAlignment = 'center';
            app.Accelerationms2GaugeLabel.Position = [671 278 111 22];
            app.Accelerationms2GaugeLabel.Text = 'Acceleration(m/s^2)';

            % Create Accelerationms2Gauge
            app.Accelerationms2Gauge = uigauge(app.UIFigure, 'circular');
            app.Accelerationms2Gauge.Limits = [-6 6];
            app.Accelerationms2Gauge.Position = [665 315 120 120];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = RealFinal_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end