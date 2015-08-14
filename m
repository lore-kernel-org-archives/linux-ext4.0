From: Olaf Hering <olaf@aepfle.de>
Subject: Re: ext4 errors with full filesystem
Date: Fri, 14 Aug 2015 11:48:31 +0200
Message-ID: <20150814094831.GA15865@aepfle.de>
References: <20150813082307.GA32614@aepfle.de>
 <20150814024227.GC26095@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:53143 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbbHNJsg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Aug 2015 05:48:36 -0400
Content-Disposition: inline
In-Reply-To: <20150814024227.GC26095@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 13, Theodore Ts'o wrote:

> On Thu, Aug 13, 2015 at 10:23:07AM +0200, Olaf Hering wrote:
> > 
> > I just got the output below in syslog with a full filesystem.
> > Should I be worried about inconsistent filesystem now, or is that just an
> > overly verbose message about ENOSPC?  This is a 4.1.5 kernel.
> 
> You don't need to worry about an inconsistent file system, but it's an
> error that isn't supposed to to happen.  The warning message indicates

I ran fsck -f anyway. There was no lost+found, I think that was removed long ago
because it conflicted with tabcompletion (ls /dist/lo<tab>). Since there was no
space left fsck was unable to create it, I think:

/lost+found not found.  Create<y>? yes
ext2fs_new_block: Could not allocate block in ext2 filesystem while trying to create /lost+found directory

Otherwise no errors reported.


> I'm curious about your workload.  How big is your file system, and how
> fragmented is your file system per e2freefrag?  And how quickly was
> various programs writing to the file system at the time when you ran
> out of space, and what sort of files and what was the average size
> that was getting dumped into the file system?  Oh, and how much memory
> did you have in your system?

Meanwhile I removed some smaller files to gain some space:
root@probook:~ # df /dist
/dev/sda5      528336856 528142072    141098 100% /dist


root@probook:~ # e2freefrag /dev/disk/by-label/DBG1S82E_dist
Device: /dev/disk/by-label/DBG1S82E_dist
Blocksize: 2048 bytes
Total blocks: 268433408
Free blocks: 0 (0.0%)

Min. free extent: 2 KB
Max. free extent: 26108 KB
Avg. free extent: 1692 KB
Num. free extent: 115

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    2K...    4K-  :            13            13     inf%
    4K...    8K-  :            10            21     inf%
    8K...   16K-  :            17           102     inf%
   16K...   32K-  :            12           129     inf%
   32K...   64K-  :            12           254     inf%
   64K...  128K-  :             6           295     inf%
  128K...  256K-  :             6           560     inf%
  256K...  512K-  :             2           359     inf%
  512K... 1024K-  :             5          1902     inf%
    1M...    2M-  :             8          5701     inf%
    2M...    4M-  :             9         12859     inf%
    4M...    8M-  :             9         27150     inf%
    8M...   16M-  :             4         24156     inf%
   16M...   32M-  :             2         23891     inf%

There was just wget writing the iso to it, it was downloaded with about
10MB/sec.  The system has 8GB RAM.

Olaf
