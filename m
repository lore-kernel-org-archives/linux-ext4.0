From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Fri, 8 Aug 2014 15:15:48 -0700
Message-ID: <20140808221548.GE11191@birch.djwong.org>
References: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22359 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbaHHWPx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 18:15:53 -0400
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 03:31:12PM -0400, TR Reardon wrote:
> Kernel 3.16, e2fsprogs 1.43-WIP (1.42.11 compiled with metadata_csum
> support), filesystems mounted with journal_async_commit.
> 
> This may be an fsck problem, hard to tell.  I consistently have
> problems with journal recovery after hard reboot when filesystem has
> metadata_csum.   Interestingly, no problems with 64-bit filesystems.
> 
> during journal replay, bogus block numbers are reported.  in this
> case, a 128MB file was deleted on two filesystems where the only
> difference is 64bit vs non-64bit.  This also happens with or without
> bigalloc, though I only document bigalloc case here.

Could you post full logs, including the bogus block numbers, please?  I've a
suspicion that we might be mishandling the 32/64 bit switch in either the
descriptor block or the revocation block, but it's hard to tell from the five
lines of log.

--D
> 
> please see attached superblocks, dumped just prior to hard reboot.
> disk8=sdm1, disk9=sdn1
> 
> dmesg:
> 
> [Fri Aug  8 15:16:28 2014] JBD2: Out of memory during recovery.
> [Fri Aug  8 15:16:28 2014] JBD2: recovery failed
> [Fri Aug  8 15:16:28 2014] EXT4-fs (sdm1): error loading journal
> [Fri Aug  8 15:16:27 2014] EXT4-fs (sdn1): recovery complete
> [Fri Aug  8 15:16:27 2014] EXT4-fs (sdn1): mounted filesystem with
> ordered data mode. Opts: journal_async_commit
> 
> 
> fsck:
> 
> #e2fsck -f -v /dev/sdm1
> e2fsck 1.43-WIP (09-Jul-2014)
> disk8: recovering journal
> Error writing block 549755813991 (Invalid argument).  Ignore error<y>? yes
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong (11332304, counted=11365072).
> Fix<y>? yes
> Free inodes count wrong (177287, counted=177288).
> Fix<y>? yes
> 
> disk8: ***** FILE SYSTEM WAS MODIFIED *****
> 
>         1656 inodes used (0.93%, out of 178944)
>          260 non-contiguous files (15.7%)
>            0 non-contiguous directories (0.0%)
>              # of inodes with ind/dind/tind blocks: 0/0/0
>              Extent depth histogram: 1280/363/5
>    721201312 blocks used (98.45%, out of 732566384)
>            0 bad blocks
>          358 large files
> 
>         1267 regular files
>          380 directories
>            0 character device files
>            0 block device files
>            0 fifos
>            0 links
>            0 symbolic links (0 fast symbolic links)
>            0 sockets
> ------------
>         1647 files



