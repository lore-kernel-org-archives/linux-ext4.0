From: Anshuman Aggarwal <anshuman@brillgene.com>
Subject: ext4 fs recovery
Date: Sat, 10 Apr 2010 04:32:49 +0530
Message-ID: <71330BF9-B4D0-4BDB-A9B7-655872791FA3@brillgene.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49206 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DIXDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 19:03:00 -0400
Received: by gyg13 with SMTP id 13so1924107gyg.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Apr 2010 16:02:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
 I have an ext4 partition which is unable to find its superblock on e2fsck. 

#e2fsck -n /dev/VGdata/LVstore 
e2fsck 1.41.11 (14-Mar-2010)
e2fsck: Superblock invalid, trying backup blocks...
e2fsck: Bad magic number in super-block while trying to open /dev/VGdata/LVstore

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>


# e2fsck -n -b 8193 /dev/VGdata/LVstore 
e2fsck 1.41.11 (14-Mar-2010)
e2fsck: Bad magic number in super-block while trying to open /dev/VGdata/LVstore

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>


Any ideas on how to proceed?

How I got here was due to a failed disk which I have ddrescued over but seems to have missing corrupt metadata.

Thanks,
Anshuman