From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: recovering from backup superblock with uninit_bg
Date: Tue, 14 Jun 2011 02:35:51 -0600
Message-ID: <E51F9800-231C-45E0-A013-9DC1749AA00C@dilger.ca>
References: <BANLkTi=Xy0hKvBe2VvO7L6cPvT94A2g+nw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43421 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1FNIfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 04:35:55 -0400
In-Reply-To: <BANLkTi=Xy0hKvBe2VvO7L6cPvT94A2g+nw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-14, at 2:15 AM, Amir Goldstein wrote:
> Can you help me figure this one out.
> 
> When I run the test:
> # mkfs.ext4 /dev/sda5
> # fsck.ext4 -nf -b 32768 /dev/sda5
> 
> The results are a total chaos.
> 
> Apparently, when opening an fs from a backup superblock,
> all _UNINIT flags are cleared:
> 
> First fsck rightfully complains that the group desc checksums are wrong.
> Then, is complains about many errors in phantom inodes, because the inode
> bitmap and tables are treated as initialized, but they aren't (see snip below)
> 
> Any idea what was the purpose of clearing the _UNINIT flags?
> Or how and if this should be fixed?

The reason that the _UNINIT flags are cleared is that they cannot possibly
be correct in the backup superblocks, and it is far more reliable to check
all of the inode table blocks for inodes, as old e2fsck used to do.

However, you shouldn't have garbage data in your inode table in the first
place.  mke2fs will normally do the inode table zeroing, unless it detects
that the kernel supports the "lazyinit zeroing thread".  At that point, it
expects the kernel to proceed to zero all of the unused blocks in the
filesystem at mount time.  If this isn't happening, it is a bug.


Cheers, Andreas





