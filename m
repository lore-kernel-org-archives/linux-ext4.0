From: Ted Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs (dm-0): unsupported inode size: 0
Date: Tue, 2 Nov 2010 10:31:43 -0400
Message-ID: <20101102143143.GB25614@thunk.org>
References: <201011021429.06471.ext4@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Pol Hallen <ext4@fuckaround.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41943 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab0KBObq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 10:31:46 -0400
Content-Disposition: inline
In-Reply-To: <201011021429.06471.ext4@fuckaround.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 02, 2010 at 02:29:06PM +0100, Pol Hallen wrote:
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

Sounds like your superblock got corrupted in an interesting way.  Try
"e2fsck -b 32768 /dev/disk".

					- Ted
