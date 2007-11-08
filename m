From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9329] New: ext4: delalloc space accounting
 problem drops data
Date: Thu, 8 Nov 2007 10:09:20 -0800
Message-ID: <20071108100920.b1c77eb0.akpm@linux-foundation.org>
References: <bug-9329-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, sandeen@redhat.com
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759006AbXKHSKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2007 13:10:03 -0500
In-Reply-To: <bug-9329-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Thu,  8 Nov 2007 09:42:10 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9329
> 
>            Summary: ext4: delalloc space accounting problem drops data
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.24-rc1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext4
>         AssignedTo: fs_ext4@kernel-bugs.osdl.org
>         ReportedBy: sandeen@redhat.com
> 
> 
> 2.6.24-rc1 + ext4 git patch queue from last week or so.
> 
> It appears that delalloc does not track used space properly, and fails to
> return ENOSPC as appropriate:
> 
> [root@bear-05 ~]# mkfs.ext3 -I 256 /dev/sdb7 32768
> [root@bear-05 ~]# mount -t ext4dev -o data=writeback,delalloc,extents,mballoc
> /dev/sdb7 /mnt/test
> [root@bear-05 ~]# df -h /mnt/test
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb7              30M  4.5M   24M  16% /mnt/test
> [root@bear-05 ~]# du -h /tmp/1Mfile 
> 1.1M    /tmp/1Mfile
> [root@bear-05 ~]# for I in `seq 1 50`; do cp /tmp/1Mfile /mnt/test/1Mfile-$I;
> done
> [root@bear-05 ~]# df -h /mnt/test
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb7              30M   30M     0 100% /mnt/test
> 
> all resulting files are 1M in length:
> [root@bear-05 ~]# ls -l /mnt/test/1M* | grep -v 1048576
> [root@bear-05 ~]# ls -l /mnt/test/1M* | grep 1048576 | wc -l
> 50
> but many of them have silently dropped data on the floor:
> [root@bear-05 ~]# du -hc /mnt/test/1Mfile-* | grep -v "1.0M"
> 596K    /mnt/test/1Mfile-26
> 0       /mnt/test/1Mfile-27
> 0       /mnt/test/1Mfile-28
> 0       /mnt/test/1Mfile-29
> 0       /mnt/test/1Mfile-30
> <snip>
> 
> When mounted with nodelalloc, I get proper behavior:
> 
> [root@bear-05 ~]# for I in `seq 1 50`; do cp /tmp/1Mfile /mnt/test/1Mfile-$I;
> done
> cp: writing `/mnt/test/1Mfile-26': No space left on device
> cp: writing `/mnt/test/1Mfile-27': No space left on device
> cp: writing `/mnt/test/1Mfile-28': No space left on device
> cp: writing `/mnt/test/1Mfile-29': No space left on device
> <snip>
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
