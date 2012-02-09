From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Thu, 9 Feb 2012 11:50:43 -0700
Message-ID: <ADF9EEFE-188A-4E88-BA8E-45D2607B1F3B@dilger.ca>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Rudolf Zran <rudolfzran@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44777 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab2BISuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Feb 2012 13:50:44 -0500
In-Reply-To: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-09, at 9:29 AM, Rudolf Zran wrote:
> I recently damaged an ext4 partition by accident (mistakenly forced
> a RAID sync with another partition onto it, which I realized after
> about 3% completion). As a result the beginning of the ext4 partition
> seems to be overwritten with garbage and refuses to mount.
> 
> As you might guess, I'd now like to get as most of my data back (from
> the part which hasn't been overwritten, of course :)).
> 
> Maybe somebody knows a good method to just "repair" the ext4-structure
> from the remaining part of the partition?
> 
> 
> Background information:
> 
> Operation system:   Debian GNU/Linux 6.0.4 (Squeeze)
> Kernel:             Linux 2.6.32-5
> Architecture:       x86-amd64
> e2fsprogs:          1.41.12
> Filesystem type:    ext4, with default settings (mkfs.ext4 /dev/xyz)
> Filesystem size:    Around 1TB, filled with around 800GB of data.
> Filesystem content: From a lot of ASCII stuff up to files with several
>                     GB in size and arbitrary non-standard type.
> 
> 
> What I've tried so far:
> 
> * First of all, though the source drive is physically fine, I work on
>   images of the partition on a spare drive, to experiment with. Everytime
>   I make unrecoverable errors to that image, I recopy the original.
> 
> * "dumpe2fs -b $SBERR /dev/loop0" does NOT work, for SBERR={32768, 98304,
>   163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 4096000,
>   7962624} ( see https://pzt.me/1l55 )
> 
> * "dumpe2fs -b $SBOK /dev/loop0" DOES (partly) work, for SBOK={11239424,
>   20480000, 23887872, 71663616, 78675968, 214990848} ( see https://pzt.me/6txz )
> 
> * "mkfs.ext4 -S /dev/loop0" results in a completely empty filesystem
> 
> * "fsck.ext4 -b $SBOK -B 4096 -v -n /dev/loop0" shows a lot of errors.
>   Filesystem isn't mountable afterwards ( see https://pzt.me/42yk and
>   https://pzt.me/3frg )
> 
> * "fsck.ext4 -b $SBOK -B 4096 -v -y /dev/loop0" recoveres after a long time.
>   Filesystem is mountable. Root is empty besides lost+found folder, which
>   contains about 300GB mostly useless data: Millions of files with wrong
>   permissions, useless names and some random content.

The ability to recover from something like this depends heavily on where
the directory structure and inodes were located.  Filesystems tend to use
the start of the disk first, because it has the best performance (about 2x
as fast as the end).

> * photorec from the testdisk package recoveres, luckily!, about 500GB of
>   data. Though the content seems to be pretty reasonable, no filenames
>   are recovered, since photorec operates without using filesystem knowledge.
> 
> Do you see any chances (besides consulting professional recovery companies)
> getting the filenames back?

There was an ext3grep tool that some people had success with, but when I
looked at it, it was still fairly complex to use.

> I looked into the ext4 specs a bit to figure out
> where this information is stored on disk, but before I step with hexedit
> through a terabyte of data, I'd rather try some solutions which are maybe
> already out there.
> 
> Any help is appretiated.
> 
> Thanks in advance, Rudolf.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





