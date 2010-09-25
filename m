From: Bernhard Rohrer <graylion@sm-wg.net>
Subject: ext4 blocksize peculiarities
Date: Sat, 25 Sep 2010 03:53:02 +0100
Message-ID: <4C9D640E.5020609@sm-wg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from collab.sm-wg.net ([86.43.106.231]:45485 "EHLO collab.sm-wg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab0IYCxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Sep 2010 22:53:04 -0400
Received: from [172.16.2.1] (lionscage.local [172.16.2.1])
	by collab.sm-wg.net (Postfix) with ESMTPSA id 42FCD180FA5
	for <linux-ext4@vger.kernel.org>; Sat, 25 Sep 2010 03:49:27 +0100 (IST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all

I have a 3.3 TB partition (yes really) that is formatted with ext4 and 4 
kiB blocks. What little data I have on that appears to use up an 
extraordinary amount of space, so I had a closer look.

root@newcollab:/home/adminlion# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/primary_vg-primary_var
                       3.5T   43G  3.3T   2% /var

we see that 43 GiB appear to be taking up something that gets rounded to 
200 GiB

if we look at:

root@newcollab:/home/adminlion# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/primary_vg-primary_var
           3696706360  44362800 3464561624   2% /var

now 44362800 4k blocks are 169.23 GiB, which does indeed round to 200 
GiB. similar usage also gets reported when I get the properties of the 
share via cifs.

debugfs shows:

Block count:              937689088
Reserved block count:      46884454
Free blocks:              912175341

so while df shows 4 times as many available 1k blocks as debugfs, which 
after all shows the actual number of 4k blocks, both are more or less in 
agreement as to the space used. This leads me to believe that somehow 
only 1k of every 4k block gets used. Now i could of course reformat to 
1k blocks, but I'd prefer to avoid that.

OS is Lucid64 and the volume is a LVM volume.

Has anybody seen this before? Uncle Google was rather mum on the subject.

cheers

Bernhard
