From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9692] New: journal_data mount option causes filesystem
 corruption with blocksize != 4096
Date: Sat, 5 Jan 2008 19:15:52 -0800
Message-ID: <20080105191552.ee114b6b.akpm@linux-foundation.org>
References: <bug-9692-27@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, h.judt@gmx.at
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028AbYAFDPi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2008 22:15:38 -0500
In-Reply-To: <bug-9692-27@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  5 Jan 2008 09:52:15 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9692
>
>            Summary: journal_data mount option causes filesystem corruption
>                     with blocksize != 4096
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.23.9
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: h.judt@gmx.at
> 
> 
> Most recent kernel where this bug did not occur: -
> Older kernels have this problem too (I think I noticed this booting >= 2.6.21,
> definitely 2.6.22).

I'm getting the feeling that we should just disable data=journal.  Make it
use data=ordered mode instead.  It isn't getting a lot of attention..

> Distribution: Gentoo Linux x86
> This bug seems to be hardware-independent (tested on three different machines
> which all use quite different drivers). If you need hardware information or any
> other log or configuration files, let me know please.
> 
> Problem Description:
> When creating an ext3 filesystem with journal_data option and block sizes
> different than 4096 (tested: 1024, 2048) filesystem corruption will occur if
> certain operations are performed (see below).
> Corruption will not occur if 4096 block size is used, or if any other block
> size is used together with journal_data_ordered or journal_data_writeback.
> No errors in dmesg.
> 
> Steps to reproduce:
> I found this bug using an audio file tagger, so you need exfalso which is part
> of quodlibet (http://www.sacredchao.net/quodlibet/). No other file tagger I
> used produced this kind of problem. Still, this has to be a kernel problem,
> right??
> 
> 1. Create ext3 file system:
> mkfs.ext3 -O has_journal,dir_index -b 1024 /dev/sdd1
> tune2fs -c 0 -i 0 -m 0 -o journal_data /dev/sdd1
> 
> tune2fs 1.40.3 (05-Dec-2007)  (filtered)
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal resize_inode dir_index filetype
> sparse_super
> Filesystem flags:         signed directory hash
> Default mount options:    journal_data
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              126976
> Block count:              1012060
> Reserved block count:     0
> Free blocks:              976865
> Free inodes:              126965
> First block:              1
> Block size:               1024
> Fragment size:            1024
> Reserved GDT blocks:      256
> Blocks per group:         8192
> Fragments per group:      8192
> Inodes per group:         1024
> Inode blocks per group:   128
> Last mount time:          n/a
> Mount count:              0
> Maximum mount count:      -1
> Check interval:           0 (<none>)
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:       128
> Journal inode:            8
> Default directory hash:   tea
> Journal backup:           inode blocks
> 
> 2. Mount it and copy mp3,ogg,... files to it. This does not cause any file
> system corruption (which you can confirm by running fsck).
> 
> pmount /dev/sdd1:
> /dev/sdd1 on /media/sdd1 type ext3 (rw,noexec,nosuid,nodev,errors=continue)
> 
> 3. Use quodlibet/exfalso to change the id3 tags. Add tags to it if not present,
> or delete them if already present. This will lead to file system corruption.
> 
> brw-r----- 1 root disk 8, 49 /dev/sdd1
> 
> 4. Unmount the volume.
> pumount /dev/sdd1
> 
> 5. Run fsck -fvD /dev/sdd1. It will complain about wrong i_size.
> 
> e2fsck 1.40.3 (05-Dec-2007)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 47106, i_size is 5015509, should be 5017600.  Fix<y>? yes
> Inode 47107, i_size is 4657736, should be 4661248.  Fix<y>? yes
> Inode 47109, i_size is 11928555, should be 11931648.  Fix<y>? yes
> Inode 47111, i_size is 5698454, should be 5701632.  Fix<y>? yes
> Inode 47112, i_size is 9384018, should be 9388032.  Fix<y>? yes
> Inode 47114, i_size is 5679228, should be 5681152.  Fix<y>? yes
> Inode 47115, i_size is 6107218, should be 6111232.  Fix<y>? yes
> Inode 47117, i_size is 4354297, should be 4358144.  Fix<y>? yes
> Inode 47118, i_size is 4512286, should be 4513792.  Fix<y>? yes
> Inode 47120, i_size is 7010846, should be 7012352.  Fix<y>? yes
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 3A: Optimizing directories
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> 
> /dev/sdd1: ***** FILE SYSTEM WAS MODIFIED *****
> 
>       28 inodes used (0.02%)
>       14 non-contiguous inodes (50.0%)
>          # of inodes with ind/dind/tind blocks: 15/15/0
>   123417 blocks used (12.19%)
>        0 bad blocks
>        0 large files
> 
>       16 regular files
>        3 directories
>        0 character device files
>        0 block device files
>        0 fifos
>        0 links
>        0 symbolic links (0 fast symbolic links)
>        0 sockets
> --------
>       19 files
> 
> Reproducible: Always.
> No binary modules were loaded, clean boot from vanilla kernel. But of course,
> also happens with gentoo-sources and tuxonice-sources and nvidia binary loaded
> ;-).
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are the assignee for the bug, or are watching the assignee.
