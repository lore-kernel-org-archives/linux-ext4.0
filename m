From: Lenky Gao <lenky.gao@gmail.com>
Subject: Inactive memory keep growing and how to release it?
Date: Tue, 12 Mar 2013 14:58:24 +0800
Message-ID: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f66.google.com ([74.125.82.66]:46992 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3CLHJr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2013 03:09:47 -0400
Received: by mail-wg0-f66.google.com with SMTP id 16so1839865wgi.9
        for <linux-ext4@vger.kernel.org>; Tue, 12 Mar 2013 00:09:46 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When i just run a test on Centos 6.2 as follows:
################################
#!/bin/bash

while true
do

        file="/tmp/filetest"

        echo $file

        dd if=/dev/zero of=${file} bs=512 count=204800 &> /dev/null

        sleep 5
done
################################

the inactive memory keep growing:

#cat /proc/meminfo | grep Inactive\(fi
Inactive(file):   420144 kB
...
#cat /proc/meminfo | grep Inactive\(fi
Inactive(file):   554662 kB
...
#cat /proc/meminfo | grep Inactive\(fi
Inactive(file):   882824 kB

and i cannot reclaim it:

# cat /proc/meminfo | grep Inactive\(file\);
Inactive(file):   882824 kB
# sync;
# echo 3 > /proc/sys/vm/drop_caches
# cat /proc/meminfo | grep Inactive\(file\);
Inactive(file):   777664 kB

My file system type is ext3, mounted with the option data=journal and
it is easy to reproduce. If the mount option is data=ordered,
reproducing this problom need more time. Because of the problom, when
in the final situation, i cannot kmalloc a larger contiguous memory,
especially in interrupt context. I have tested on other version
kernel, such as 2.6.30 and 3.6.11, the problom also exists.

Is this a bug?

Or can you give some tips to avoid this?

-- 
Regards,

Lenky
