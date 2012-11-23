From: Mark Casey <markc@unifiedgroup.com>
Subject: e2fsck repeatedly asks to clear the same entry?
Date: Fri, 23 Nov 2012 12:26:52 -0600
Message-ID: <k8of5a$sjb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36242 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2KWS1I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Nov 2012 13:27:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Tbxy7-0002k8-Nm
	for linux-ext4@vger.kernel.org; Fri, 23 Nov 2012 19:27:15 +0100
Received: from cpe-76-183-161-185.tx.res.rr.com ([76.183.161.185])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 23 Nov 2012 19:27:15 +0100
Received: from markc by cpe-76-183-161-185.tx.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 23 Nov 2012 19:27:15 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello list,

I'm in a bit of a loop trying to fix my ext4 filesystem; it always goes 
like this even after several passes.

> root@host:/home/luser# /root/latest/sbin/e2fsck -f /dev/vgdalr6/lv1
> e2fsck 1.42.5 (29-Jul-2012)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Entry 'A5 11-3' in /share/path/09/Brett/Pines/Flynt's Side Drive - Complete Archive Copy/SA Version Pines/Chris Pics 11-2-10 (268533857) has deleted/unused inode 15115.  Clear<y>? yes
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
>
> /dev/vgdalr6/lv1: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/vgdalr6/lv1: 8993801/268697600 files (0.8% non-contiguous), 2152234742/4299161600 blocks
> root@host:/home/luser#


Would anyone have any suggestions how to proceed?

The cause of this is that I did an unsupported resize (a shrink) by 
commenting out one of resize2fs' checks...as described here: (note I'm 
not claiming this as "permission"; I knew it might not work)

http://article.gmane.org/gmane.comp.file-systems.ext4/35375

resize2fs gave no indication of trouble but the check that followed 
didn't go perfectly. 6 or 7 directory entries needed to be cleared and 
I've restored ~10gb from backup, but otherwise this current issue with 
the directory 'A5 11-3' is the only symptom presenting. I have most of 
the e2fsck log that followed the resize in case that would be of use.

Thank you,
Mark

