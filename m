From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: gdisk-created Bios Boot Partition created with NO fs, reports fs
 TYPE=ext4.  Bug/why?
Date: Mon, 16 Feb 2015 10:38:49 -0800
Message-ID: <20150216183849.GA11031@birch.djwong.org>
References: <1424025536.1061731.227795501.40064DE9@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: grantksupport@operamail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47153 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbbBPSi7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Feb 2015 13:38:59 -0500
Content-Disposition: inline
In-Reply-To: <1424025536.1061731.227795501.40064DE9@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 15, 2015 at 10:38:56AM -0800, grantksupport@operamail.com wrote:
> I'm not entirely sure this is the right list for this question, but it IS ext4 'involved'.  So ...
> 
> I create a GPT Bios Boot Partition on a clean disk
> 
> 	sgdisk -z /dev/sdc
> 	sgdisk -o /dev/sdc
> 	sgdisk -n 1:2048:+1M    -t 1:ef02  -c 1:"BIOS Boot"           /dev/sdc
> 
> IIUC, at this point, the partition should exist with NO filesystem.
> 
> But, if I check with blkid
> 
> 	blkid /dev/sdc1
> 		/dev/sdc1: LABEL="RAID_BOOT" UUID="8a828baa-f315-4456-88d2-ff14849eb705" TYPE="ext4" PARTLABEL="BIOS Boot" PARTUUID="2b3b10b1-a458-481e-872c-bada7d244b13" 
> 
> Note that it IDs the filesystem type as
> 
> 	TYPE="ext4"
> 
> Why?

Wiping the partition table doesn't erase filesystem superblocks, so if there
previously was an sdc1 with an ext4 partition and the new sdc1 starts at the
same offset, the old fs is still accessible.

> Bios Boot Partition should have NO filesystem.
> 
> Is blkid correct?  Is there, or isn't there a fs on that partition?
> 
> if there isn't, what's causint the 'false' report?
> 
> If there IS, how do I make sure there isn't?

wipefs.

--D
> 
> grant
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
