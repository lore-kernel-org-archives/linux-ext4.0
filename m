From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 errors not going away after fsck
Date: Thu, 25 Nov 2010 12:09:17 -0700
Message-ID: <6FEDAEDB-16B5-4D8A-B820-E234D61DB540@dilger.ca>
References: <4CEE7975.10809@wpkg.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45030 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0KYTJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 14:09:31 -0500
In-Reply-To: <4CEE7975.10809@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-25, at 07:57, Tomasz Chmielewski wrote:
> I have a system which had bad memory.
> 
> Bad memory was replaced, but filesystem corruption caused by it (and related crashes) is still there:
> 
> [104472.909769] EXT4-fs (vdb1): mounted filesystem with ordered data mode. Opts: errors=remount-ro
> [104773.600088] EXT4-fs (vdb1): error count: 2
> [104773.600093] EXT4-fs (vdb1): initial error at 1290468286: htree_dirblock_to_tree:586: inode 30204507: block 120625971
> [104773.600097] EXT4-fs (vdb1): last error at 1290468334: ext4_put_super:726: inode 30204507: block 120625971

The "initial error" handling has been fixed in the e2fsprogs git repo.  Search the archives for the patch.

> The error is exactly the same as the first one I pasted (multiple umount, fsck, mount runs without reboot).
> 
> Is this all something to be worry about?

No, this is just a historical log of what caused the filesystem problems.  It doesn't mean that there is anything wrong with the filesystem now.

Cheers, Andreas





