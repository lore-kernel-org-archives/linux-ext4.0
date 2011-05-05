From: Ling Ho <ling@slac.stanford.edu>
Subject: resize4fs: File too large while trying to determine filesystem size
Date: Thu, 05 May 2011 12:48:45 -0700
Message-ID: <4DC2FF1D.6040903@slac.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nospam5.slac.stanford.edu ([134.79.18.83]:57980 "EHLO
	nospam5.slac.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1EEUAJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 16:00:09 -0400
Received: from mailgate05.slac.stanford.edu (mailgate05.slac.stanford.edu [134.79.18.85])
	by nospam5.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id p45Jml4R010253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 5 May 2011 12:48:47 -0700
	(envelope-from ling@slac.stanford.edu)
Received: from [134.79.165.22] (psdev102.slac.stanford.edu [134.79.165.22])
	by mailgate05.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id p45Jmjf0010375
	for <linux-ext4@vger.kernel.org>; Thu, 5 May 2011 12:48:46 -0700 (PDT)
	(envelope-from ling@slac.stanford.edu)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am trying to resize a ext4 filesystem. I am using e4fsprogs 1.41.12.

My device is actually 17TB. I can live with just using 16TB of it if 
that's what's supported. But when I tried to increase the size by 
specifying the size, I get this error:

# resize4fs /dev/sdb 16000G
resize4fs 1.41.12 (17-May-2010)
resize4fs: File too large while trying to determine filesystem size
# resize4fs /dev/sdb 15000G
resize4fs 1.41.12 (17-May-2010)
resize4fs: File too large while trying to determine filesystem size


I also tried 16T and 15T, and get the same thing.

# cat /proc/partitions
major minor  #blocks  name

    8     0  243163136 sda
    8     1   16779861 sda1
    8     2    6289447 sda2
    8     3    6289447 sda3
    8     4          0 sda4
    8     5    4192933 sda5
    8     6    4192933 sda6
    8     7    4192933 sda7
    8     8  201222126 sda8
    8    16 17560535040 sdb

# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1             16253924   9484080   5930852  62% /
/dev/sda8            194917600  66106672 118749824  36% /u1
/dev/sda6              4061540     83700   3768196   3% /tmp
/dev/sda3              6092388    221168   5556748   4% /opt
/dev/sda2              6092388   4701480   1076436  82% /var
/dev/sda5              4061540     73800   3778096   2% /var/tmp
tmpfs                 16481060         0  16481060   0% /dev/shm
/dev/sdb             2880829872 1505086604 1229405476  56% /u2

Can someone suggest I am doing wrong?

Thanks,
...
ling
