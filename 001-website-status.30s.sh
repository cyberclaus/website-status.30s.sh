#!/bin/zsh
# ############################################################################
#                                                                            #
#    001-website-status.xs.sh        (x stands for seconds to check)         #
#                                                                            #
#                                                                            #
#    a "plugin" for xbar             Klaus-J Luksch  (2021-11-20)            #
#                                                                            #
#    checks websites                                                         #
#                                                                            #
##############################################################################
#
#
# Metadata allows your plugin to show up in the app, and website.
#
#  <xbar.title>Service-Status</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Klaus-J Luksch</xbar.author>
#  <xbar.author.github>cyberclaus</xbar.author.github>
#  <xbar.desc>Checks status of websites</xbar.desc>
#  <xbar.image>https://github.com/cyberclaus/website-status.30s.sh/blob/main/screenshot.png</xbar.image>
#  <xbar.dependencies>zsh</xbar.dependencies>
#  <xbar.abouturl>https://github.com/cyberclaus/website-status.30s.sh/blob/main/about</xbar.abouturl>#
#
#
# websites
#
declare -A sites;
declare -A results;
#
#
#################################################################################################################
# add as many sites as you want in this [STRIKT] syntax  sites+=('consecutive number' 'https://sitename.tld')   #
#################################################################################################################
#
sites+=('0' 'https://apple.com');
sites+=('1' 'https://experience.arcgis.com');
sites+=('2' 'https://www.macupdate.com');
sites+=('3' 'https://impfdashboard.de');
sites+=('4' 'https://www.corecode.io/macupdater/');
#
#################################################################################################################
# no need to change anything below this line                                                                    #
#################################################################################################################
#
#
# statusmessages in form of a symbol
#
SuccessStatus='🟢';
WarningStatus='🟠';
ErrorStatus='🔴';
#
#
# check every single site and store rc in new array
#
for ((i=0; i<${#sites[@]}; i++));
    do
    results+=($i $(curl -s -I -L -w "%{http_code}" ${sites[$i]} | tail -n 1 | cut -c 1-3));
done
#
#
#
# headline with total status
#
declare -i rc200=0;
declare -i rc000=0;
#
for ((i=0; i<${#results[@]}; i++));
    do
        if [[ "${results[$i]}" == "200" ]]; then
            rc200+=1;
        elif [[ "${results[$i]}" != "200" ]]; then
            rc000+=1;
        fi
done;
#
#
if [[ ${#results[@]} -eq $rc200 ]]; then
	echo -e 'Sites: ' $SuccessStatus;
elif [[ ${#results[@]} -eq $rc000 ]]; then
	echo -e 'Sites: ' $ErrorStatus;
else
	echo -e 'Sites: ' $WarningStatus;
fi
#
#
#
# add headline separator line
echo '---';
#
#
# now the single array elements for the sub menu
#
for ((i=0; i<${#sites[@]}; i++));
    do
        if [[ "${results[$i]}" == "200" ]]; then
        	echo -e ${SuccessStatus} "\t" ${sites[$i]};
	    else
	        echo -e ${ErrorStatus} "\t" ${sites[$i]};
        fi;
done;	
#
exit;
