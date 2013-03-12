From: Lenky Gao <lenky.gao@gmail.com>
Subject: Re: Inactive memory keep growing and how to release it?
Date: Tue, 12 Mar 2013 16:48:02 +0800
Message-ID: <CAAO_Xo5iK=mnLzxeRCWq_qMkm2NLotDfYZEQZrwyKurNGnOeZw@mail.gmail.com>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
	<20130312083711.GA1943@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Lenky Gao <lenky.gao@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:57539 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3CLIsE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2013 04:48:04 -0400
Received: by mail-we0-f170.google.com with SMTP id z53so4423479wey.15
        for <linux-ext4@vger.kernel.org>; Tue, 12 Mar 2013 01:48:02 -0700 (PDT)
In-Reply-To: <20130312083711.GA1943@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 4:37 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi Gao,
> I don't think it is a bug.  If I understand correctly, when you try to
> reclaim memory (sync and drop caches), the test script is still running,
> right?  If so, that means that some memory will be re-dirtied again.  So
> the number of inactive pages could not reduce as you expected.

The test script has stopped.

Some log messages came from my UML Linux as follows:

...
/sdb/file_test
             total       used       free     shared    buffers     cached
Mem:           182        179          2          0         10         13
-/+ buffers/cache:        155         27
Swap:            0          0          0
/sdb/file_test
^C
[root@localhost ~]#
[root@localhost ~]# sync;
[root@localhost ~]# echo 3 > /proc/sys/vm/drop_caches
[root@localhost ~]#
[root@localhost ~]# echo 3 > /proc/sys/vm/drop_caches
[root@localhost ~]# sync;
[root@localhost ~]# echo 3 > /proc/sys/vm/drop_caches
[root@localhost ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           182        157         25          0          0          3
-/+ buffers/cache:        153         28
Swap:            0          0          0

[root@localhost ~]# cat /proc/meminfo | grep Inac
Inactive:         124756 kB
Inactive(anon):     1408 kB
Inactive(file):   123348 kB
[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.30.8 #20 Mon Mar 11 07:04:06 EDT 2013
x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# mount | grep sdb
/dev/ubdb1 on /sdb type ext3 (rw,data=journal)
[root@localhost ~]# cat ./test_write_disk.sh
#!/bin/bash

while true
do

#       file="/sdb/file_`date +%y%m%d%k%m%s`"
        file="/sdb/file_test"

        echo $file

        dd if=/dev/zero of=${file} bs=512 count=20480 &> /dev/null

#	sync
#	cat /proc/meminfo | grep Inactive\(file\)
	free -m

#        rm -fr ${file}
done

-- 
Regards,

Lenky
