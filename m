From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11873] New: unable to mount ext3 root
 filesystem due to htree_dirblock_to_tree
Date: Tue, 28 Oct 2008 10:31:22 -0700
Message-ID: <20081028103122.728aa427.akpm@linux-foundation.org>
References: <bug-11873-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, Jimmy.Jazz@gmx.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbYJ1Rb4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2008 13:31:56 -0400
In-Reply-To: <bug-11873-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 28 Oct 2008 05:09:25 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11873
> 
>            Summary: unable to mount ext3 root filesystem due to
>                     htree_dirblock_to_tree
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.28 rcx git and vanilla trees
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: Jimmy.Jazz@gmx.net
>                 CC: Jimmy.Jazz@gmx.net
> 
> 
> Latest working kernel version:2.6.27.3
> Earliest failing kernel version:2.6.28 rc1 git1
> Distribution: gentoo
> Hardware Environment: x86_64 amd
> Software Environment: kernel + initramfs
> Problem Description:
> 
> Since 2.6.28 mount command (busybox) is unable to mount the root file system.
> The error returned is,
> 
> EXT3-fs error (device md_d0p2): htree_dirblock_to_tree: bad entry in directory
> #2: rec_len % 4 != 0 - offset=0, inode=2109536318, rec_len=16058, name_len=111
> 
> (The figures could change)
> 
> 
> To make it work, I need first to mount the file system as an ext2 file system,
> unmount it and recall mount command with the -t ext3 option.
> 
> step 1:
> mount -o ro /dev/md/d0p2 /new-root
> (mount ok with flags ro,errors=continue)
> ls /new-root
> (ls without error)
> umount /new-root
> 
> and then
> 
> step 2:
> mount -t ext3 -o ro /dev/md/d0p2 /new-root
> (mount ok with flags ro,errors=continue,data=ordered)
> ls /new-root
> (ls without error)
> 
> ext2,jbd,ext3,mbcache,crc32 are modules and are loaded from an initramfs file
> system.
> 
> IMHO, it is a problem in mbcache or jbd.
> 
> Also, there is an other problem with that kernel. After creating the /dev node,
> loading md_mod and raid1, mdassemble start as usual the md device, but the
> mount command doesn't recognize the /dev node as valid and abort. 
> I need to stop the md device that has been created earlier and reapply
> mdassemble or mdadm --assemble --scan from initramfs file system. Afterwards
> mount command is able to mount the file system but... like an ext2 file system.
> I'm on step 2 again.
> 
> 
> Steps to reproduce: reboot the kernel, load the initramfs file system and open
> a shell just after the mount command has aborted.
> 

