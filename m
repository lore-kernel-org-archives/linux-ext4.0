From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Fri, 22 Apr 2011 10:37:39 GMT
Message-ID: <201104221037.p3MAbdg6012184@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:33348 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1DVKhj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 06:37:39 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3MAbdRX012185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Apr 2011 10:37:39 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #61 from rocko <rockorequin@hotmail.com>  2011-04-22 10:37:37 ---
I can reliably reproduce it with the following, running in Ubuntu (11.04 at the
moment, but 10.10 works as well):

1. I insert a USB key formatted with ext4.

2. I run this simple script, passing the id that shows up in
/sys/bus/usb/drivers/usb-storage for the USB key as the argument, eg 2-2:1.0:

#!/bin/bash
SLEEP=3
function list {
  if [ -e "$1" ]; then
    echo $1
  fi
}

cd /sys/bus/usb/drivers/usb-storage
if [ "$1" == "" ] || [ "$2" != "" ]; then
  echo "Usage: $0 usb device"
  echo "With one of these: "
  for file in 1* ; do list $file; done
  for file in 2* ; do list $file; done
  exit 1
fi

echo 8 > /proc/sys/kernel/printk
count=1
while true; do
  echo -n $1 >unbind
  echo $count
  sleep $SLEEP
  echo -n $1 >bind
  sleep $SLEEP
  ((count=count+1))
done



I'm making it sleep 3 seconds between unbind/bind events because that gives
Ubuntu plenty of time to mount the drive after the bind.

When it oopses, it typically oopses within a few seconds of the unbind event
(I'd say in less than 10 seconds and often immediately). For me it normally
will oops inside 10 bind/unbinds, but 2.6.39-rc4 took more like 20 to 30 goes
when I tried it this morning).

I'll try again sending the output to another PC, but I'm pretty sure last time
I tried that the ssh session crashed before it could dump the stack trace, just
as the tty console usually crashes before it finishes dumping.

When I get time I'll try some variations as well like making it sync and sleep
before the unbind.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
