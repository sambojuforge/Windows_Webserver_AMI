title 'Ensure IIS is installed via Windows Features'

    describe windows_feature('Web-Server') do
        it { should be_installed }
    end
  
title 'Ensure IIS Service is running'
    
    describe service('W3SVC') do
        it { should be_installed }
        it { should be_running }
    end

title 'Ensure URL Rewrite is installed'

    describe package('IIS URL Rewrite Module 2') do
        it { should be_installed }
    end    

title 'Ensure Web Deploy is installed'

    describe package('Microsoft Web Deploy 3.6') do
        it { should be_installed }
    end  

title 'Ensure ASP.NET MVC is installed'

    describe package('Microsoft ASP.NET MVC 3') do
        it { should be_installed }
    end    

title 'Ensure ASP.NET MVC 4 is installed'

    describe package('Microsoft ASP.NET MVC 4') do
        it { should be_installed }
    end  

title 'Ensure the default web site does not exist'

    describe iis_site('Default Web Site') do
        it { should_not exist }
    end

title 'Ensure files in the wwwroot folder does not exist'

    describe file('C:\inetpub\wwwroot\iisstart.htm') do
        it { should_not exist }
    end    

title 'Ensure web.root folder exist'

    describe directory('C:\web.root') do
        it { should exist }
    end

title 'Ensure web.logs folder exist'

    describe directory('C:\web.logs') do
        it { should exist }
    end
