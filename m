From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: journal has aborted
Date: Mon, 7 Jul 2014 15:31:24 -0700
Message-ID: <20140707223124.GA24006@birch.djwong.org>
References: <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org>
 <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
 <20140707141701.2f9529af@archvile>
 <20140707155310.GB8254@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Jander <david@protonic.nl>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50087 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGGWbl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2014 18:31:41 -0400
Content-Disposition: inline
In-Reply-To: <20140707155310.GB8254@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Whatever this bug is, I hit it on a spinny disk with 3.15.0.

Disk: APPLE HDD HTS541010A9E662 (Hitachi SATA disk in a Mac Mini)
Kernel: 3.15.0 (fairly standard build; didn't have problems w/ 3.14)
OS: Ubuntu 14.04 + e2fsprogs 1.42.10 (May 2014)

That machine hadn't been rebooted for a couple of weeks, when I rebooted it to
put 3.15.4 on the machine (ptrace bug fix).  When 3.15.4 came up, I saw this in
dmesg:

[   31.717188] EXT4-fs (dm-3): recovery complete
[   31.721056] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: discard
<snip>
[  213.150808] EXT4-fs error (device dm-3): ext4_mb_generate_buddy:756: group 4803, 12227 clusters in bitmap, 12217 in gd; block bitmap corrupt.
[  213.150822] JBD2: Spotted dirty metadata buffer (dev = dm-3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.

After which I umounted the FS and ran e2fsck -n: 

# e2fsck -fn /dev/dm-3 -C0
e2fsck 1.42.10 (18-May-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure                                           
Pass 3: Checking directory connectivity                                        
Pass 4: Checking reference counts
Pass 5: Checking group summary information                                     
Block bitmap differences:  -(157397995--157398003) -(157398006--157398014)
-(157403147--157403184) -(157403237--157403242) -(157403258--157403273)
-(157403280--157403505) -(157403508--157403647)
Fix? no

dumpe2fs shows this for BG 4803:

Group 4803: (Blocks 157384704-157417471) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xfbd1, unused inodes 8192
  Block bitmap at 157286403 (bg #4800 + 3), Inode bitmap at 157286419 (bg #4800 + 19)
  Inode table at 157287968-157288479 (bg #4800 + 1568)
  12233 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 157384770, 157384840-157384888, 157385059-157385087,
157385213-157385215, 157385283-157385285, 157385408, 157385469-157385471,
157385779-157385780, 157385846, 157385916-157385918, 157386119-157386175,
157386235-157386239, 157386563-157386571, 157386641-157386687,
157387037-157387062, 157387331, 157387531-157387555, 157387624-157387646,
157387725-157387775, 157388100-157388130, 157388523-157388543,
157388942-157389055, 157389258-157389300, 157389379-157389428,
157389795-157390137, 157390294-157390591, 157390798-157390847,
157391360-157391524, 157391594-157391871, 157391950-157392009,
157392073-157392309, 157392455-157392536, 157392604-157393151,
157393423-157394310, 157394377-157394431, 157395200-157395261,
157395320-157395342, 157395408-157395455, 157395968-157396438,
157396440-157396735, 157396799-157397005, 157397007-157397994,
157398004-157398005, 157398015, 157398272-157398527, 157399040-157399104,
157399106-157399757, 157399759-157400094, 157400177-157400190,
157400210-157400223, 157400404-157400419, 157400459-157400494,
157400571-157400831, 157401600-157401696, 157401698-157402124,
157402126-157402833, 157402835-157402836, 157402839-157403146,
157403185-157403214, 157403226-157403236, 157403243-157403257,
157403274-157403279, 157403506-157403507, 157403648-157403865,
157403867-157404241, 157404250-157404671, 157405440-157405695,
157406464-157406564, 157406710-157406764, 157406768-157407086,
157407088-157407231, 157407271-157407487, 157407744-157407975,
157408034-157408149, 157408672-157408676, 157408736-157408766,
157409000-157409023, 157409280-157409785, 157412864-157413119
  Free inodes: 39346177-39354368

I then had the funny idea to copy all of those blocks out of the filesystem to
see what had previously been stored there.  Of the files that weren't
unintelligible binary crud, the recognizable blocks (according to file(1))
mostly appear to be HTML, CSS, and JPEG files from Firefox's browser cache.
There's nothing obviously wrong with Fx's cache directory, though.

Anyway, I'll keep digging.

--D

On Mon, Jul 07, 2014 at 11:53:10AM -0400, Theodore Ts'o wrote:
> An update from today's ext4 concall.  Eric Whitney can fairly reliably
> reproduce this on his Panda board with 3.15, and definitely not on
> 3.14.  So at this point there seems to be at least some kind of 3.15
> regression going on here, regardless of whether it's in the eMMC
> driver or the ext4 code.  (It also means that the bug fix I found is
> irrelevant for the purposes of working this issue, since that's a much
> harder to hit, and that bug has been around long before 3.14.)
> 
> The problem in terms of narrowing it down any further is that the
> Pandaboard is running into RCU bugs which makes it hard to test the
> early 3.15-rcX kernels.  There is some indication that the bug showed
> up in the ext4 patches which Linus pulled at the beginning of
> 3.15-rc3.  However, due to the ARM (or at least Pandaboard) RCU bugs,
> it's not possible to bisect test this on the Pandaboard.
> 
> And on the x86_64, it takes most of a day to confirm the absence of a
> test failure.  (Although this is with a HDD, so assuming that we don't
> have an eMMC as well as an ext4 regression in 3.15, it seems likely
> that the problem is with some kind of ext4 regression sometime between
> 3.14 and 3.15.
> 
> So we are making progress, but it's slow.  Hopefuly we'll know more in
> the near future.
> 
> Thanks to everyone who has been working on this bug!
> 
> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
