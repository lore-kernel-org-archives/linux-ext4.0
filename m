From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: What is status of metadata_csum
Date: Fri, 17 Jan 2014 11:21:17 -0800
Message-ID: <20140117192117.GC3897@birch.djwong.org>
References: <52D7BB10.5090003@rempel-privat.de>
 <20140117020009.GL9229@birch.djwong.org>
 <52D8E755.6030205@rempel-privat.de>
 <52D9084B.8030501@rempel-privat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Oleksij Rempel <linux@rempel-privat.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43950 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaAQTVZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jan 2014 14:21:25 -0500
Content-Disposition: inline
In-Reply-To: <52D9084B.8030501@rempel-privat.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 17, 2014 at 11:39:07AM +0100, Oleksij Rempel wrote:
> Am 17.01.2014 09:18, schrieb Oleksij Rempel:
> > Am 17.01.2014 03:00, schrieb Darrick J. Wong:
> >> On Thu, Jan 16, 2014 at 11:57:20AM +0100, Oleksij Rempel wrote:
> >>> What is metadata_csum status?
> >>>
> >>> i see there are benchmark updates on wiki page, but no updates for
> >>> e2fsprogs. 1.43-WIP seems to be really old.
> >>
> >> Still waiting for 1.43.  I don't know if there are early adopters running
> >> 1.43-WIP without complaint, or if simply nobody's using it at all. :/
> > 
> > I didn't tested current master.git - my bad. It is not outdated :)
> > 
> > Beside, the wiki should be corrected. If you enable 64bit, it will need
> > extents too.
> > 
> > Are there any existing tools for error injection for file systems?
> > Random read error from libata or silent data corruptions?
> > 
> 
> I was playing with metadata_csum trying to kill my system and now i have
> some questions:
> 
> first the test:
> #find block number
> sudo ./debugfs/debugfs -R "imap <3991825>" /dev/sdf1
> 
> #copy block
> sudo dd if=/dev/sdf1 bs=4K count=1 skip=15958163 of=corrupt_block.bin
> 
> #change one byte
> ghex corrupt_block.bin
> 
> #kill inode
> sudo dd of=/dev/sdf1 bs=4K count=1 seek=15958163 if=corrupt_block.bin
> 
> sudo ./debugfs/debugfs -R "stat <3991825>" /dev/sdf1
> #stat: Inode checksum does not match inode while reading inode 3991825
> 
> so, inode is corrupt:
> - ext4 can detect inode corruption. Great work! I like it :)
> - in this case file will not be shown by Nautilus.
> - ls will show some thing like this:
> 
> 4130898 drwx------  8 oleksij oleksij      4096 Jan 17 09:31 Bilder
>       ? -?????????  ? ?       ?               ?            ?
> ich-einfach_unverbesserlich_2.mkv
> 3991826 -rw-rw-r--  1 oleksij oleksij 622038707 Jan 17 11:12 igor.mkv
> 3989506 drwxr-xr-x 26 oleksij oleksij      4096 Okt  9 23:11 linux
> 
> it means, i know there is some thing wrong, but i do not know which inode

Unfortunately, either the whole stat call succeeds or it doesn't.  Your best
bet to find the inode is:
debugfs -n -R 'stat /path/within/fs' /dev/sdXXX

> - If fs is not fixed, file is lost? are blocks still allocated to this
> inode?

Yes, the blocks are still allocated.

> - debufs will not allow me to edit inode corrupt inode.

debugfs -n (disables checksum verification)

> - If i run fsck -y file is lost. Most user wont be able to recover it.

If you answer 'n' to the first prompt about the checksum failure, e2fsck will
check the rest of the inode.  If no other problems are found, it'll ask to
correct the checksum.

I've wondered if perhaps e2fsck ought to do something like this when there's a
checksum problem:

1. If the user didn't prohibit clearing the inode as the first potential
   action, ask if e2fsck should just clear the inode.
2. If not, run the regular checks.
3. If there's still a checksum error, ask to fix the checksum.
4. If the user doesn't want to fix it, ask to clear the inode.

iow, e2fsck --verify-checksums-last /dev/sdXX

> - how can i sync it with back up software?

fsck -y to clear the bad inode, then restore from backup.

--D
