From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs (dm-0): unsupported inode size: 0
Date: Tue, 02 Nov 2010 09:22:19 -0500
Message-ID: <4CD01E9B.9060702@redhat.com>
References: <201011021429.06471.ext4@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Pol Hallen <ext4@fuckaround.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0KBOWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 10:22:23 -0400
In-Reply-To: <201011021429.06471.ext4@fuckaround.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/2/10 8:29 AM, Pol Hallen wrote:
> Hi folks :-)
> 
> on a backup usb disk I've formatted ext4 (debian stable, kernel (2.6.32 
> vanilla).
> 
> Later sometimes when i try to mount this disk in syslog I see:
> 
> EXT4-fs (dm-0): unsupported inode size: 0
> 
> the health how disk is good..
> 
> tune2fs -l /dev/disk is:
> 
> tune2fs 1.41.12 (17-May-2010)
> tune2fs: Filesystem revision too high while trying to open /dev/mapper/pp
> Couldn't find valid filesystem superblock.
> 
> what is the problem? Is an ext4 problem?

Seems the disk is badly corrupted.

What does blkid /dev/mapper/pp say?  Maybe it's got something besides
ext4 on it now.

-Eric

> what can I do to fix the problem?
> thanks :-)
> 
> Pol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

