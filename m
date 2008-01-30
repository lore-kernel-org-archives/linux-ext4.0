From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9855] New: ext3 ACL corruption
Date: Wed, 30 Jan 2008 14:49:30 -0800
Message-ID: <20080130144930.e23f78de.akpm@linux-foundation.org>
References: <bug-9855-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, kmshanah@ucwb.org.au
To: linux-ext4@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452AbYA3WuK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 17:50:10 -0500
In-Reply-To: <bug-9855-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 30 Jan 2008 14:29:27 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9855
> 
>            Summary: ext3 ACL corruption
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.23
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: kmshanah@ucwb.org.au
> 
> 
> Latest working kernel version: Unknown
> Earliest failing kernel version: Definitely 2.6.23 and 2.6.23.8 but earlier is
> possible
> Distribution: Debian Etch
> Hardware Environment: Multiple x86 machines
> 
> Software Environment:
> Filesystem is Ext3 on LVM on RAID-1 (on SATA).
> # e2fsck -V
> e2fsck 1.40-WIP (14-Nov-2006)
>         Using EXT2FS Library version 1.40-WIP, 14-Nov-2006
> 
> Problem Description:
> On several occasions now I have had e2fsck prune away ACLs on my file systems
> during a file system check after rebooting a number of (reasonably) long
> running Samba servers. This morning I decided to manually run fsck before
> rebooting one of these:
> 
> # e2fsck -pfv /dev/mapper/vg_main-lv_samba
> (entry->e_value_offs + entry->e_value_size: 116, offs: 120)
> /dev/mapper/vg_main-lv_samba: Extended attribute in inode 163841 has a value
> offset (56) which is invalid
> CLEARED.
> (entry->e_value_offs + entry->e_value_size: 116, offs: 120)
> /dev/mapper/vg_main-lv_samba: Extended attribute in inode 262146 has a value
> offset (56) which is invalid
> CLEARED.
> [ snip lots of (near) identical errors]
> 
>     8301 inodes used (0.08%)
>     1621 non-contiguous inodes (19.5%)
>          # of inodes with ind/dind/tind blocks: 3837/24/0
>  1108478 blocks used (5.29%)
>        0 bad blocks
>        1 large file
> 
>     7590 regular files
>      662 directories
>        0 character device files
>        0 block device files
>        0 fifos
>        0 links
>       40 symbolic links (38 fast symbolic links)
>        0 sockets
> --------
>     8292 files
> 
> (Note: after remounting)
> # tune2fs -l /dev/mapper/vg_main-lv_samba 
> tune2fs 1.40-WIP (14-Nov-2006)
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          88677414-c1f8-41ba-b737-d9f6170d771b
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
> needs_recovery sparse_super large_file
> Filesystem flags:         signed directory hash 
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              10485760
> Block count:              20971520
> Reserved block count:     1048576
> Free blocks:              19863038
> Free inodes:              10477459
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      1019
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         16384
> Inode blocks per group:   1024
> Filesystem created:       Wed Feb 21 21:38:33 2007
> Last mount time:          Thu Jan 31 03:18:54 2008
> Last write time:          Thu Jan 31 03:18:54 2008
> Mount count:              1
> Maximum mount count:      30
> Last checked:             Thu Jan 31 03:16:51 2008
> Check interval:           15552000 (6 months)
> Next check after:         Tue Jul 29 02:16:51 2008
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      be8c201b-3563-4fa5-a2a6-e2864e4b73e2
> Journal backup:           inode blocks
> 
> 
> Steps to reproduce:
> Unfortunately, precise steps are not known. Restoring all the filesystem's ACLs
> from a recent dump made using "getfacl -RP" fixes the ACLs without causing the
> corruption to return.
> 
> These are production Samba servers making fairly extensive use of file and
> directory ACLs. Thus far, I've only noticed the corruptions when it came time
> to upgrade to a new kernel and reboot (and the boot scripts then run fsck).
> Note that I've never noticed any issues at runtime because of this - only when
> I later realised that ACLs had been removed from random files and/or
> directories.
> 
> I think I will implement some scripts to unmount and run fsck nightly from
> cron, so I can at least detect the corruption a little earlier. If there is
> some more helpful debugging output I can provide, please let me know.
> 
