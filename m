From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mpage_da_map_blocks block allocation failed for inode
Date: Thu, 04 Jun 2009 13:03:23 -0500
Message-ID: <4A280C6B.9010501@redhat.com>
References: <2D5FAD5D-A5EA-4742-82C5-1F694006F171@mobygames.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Brian Hirt <bhirt@mobygames.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37029 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZFDSD1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 14:03:27 -0400
In-Reply-To: <2D5FAD5D-A5EA-4742-82C5-1F694006F171@mobygames.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Brian Hirt wrote:
> A few hours ago, one of my servers encountered an error with EXT4, and  
> the filesystem remounted read only.   The filesystem is on top of LVM  
> and a 3 disk U320 RAID5 array using an adaptec ZCR card.   The array  
> and all the drives in it are reporting optimal status and I don't  
> suspect a hardware problem.  I was able to reboot into single user and  
> manually fsck the filesystem and get it back running, but I feel like  
> I have a ticking time bomb that will explode again, possible with  
> worse results.
> 
> The server is running Ubuntu 9.04 with the Ubuntu supplied kernel  
> 2.6.28-11-server.   I've included some output below from dmesg, uname  
> and fsck.
> 
> I don't know if this issue has been fixed yet, and I don't know what I  
> should do next time it happens to help provide better information.   
> Any advise on how to continue would be much appreciated.
> 
> Thanks for your help.
> 
> [2034064.210495] EXT4-fs error (device dm-0): ext4_mb_generate_buddy:  
> EXT4-fs: group 111: 20092 blocks in bitmap, 20093 in gd

This is the real first error, not the later mpage_da_map_blocks error,
which is just a follow-on because the fs has gone readonly.

> [2034064.342923]
> [2034064.342927] Aborting journal on device dm-0:8.
> [2034064.398960] Remounting filesystem read-only
> [2034064.452676] mpage_da_map_blocks block allocation failed for inode  
> 72 at logical offset 512 with max blocks 1 with error -30

#define EROFS           30      /* Read-only file system */

> [2034064.588242] This should not happen.!! Data will be lost

TBH I think this error message is a bit misleading... in this case
(filesystem shutdown) this is exactly what should happen....

> [2034064.652949] ext4_da_writepages: jbd2_start: 1006 pages, ino 72;  
> err -30
> [2034064.734390] Pid: 30013, comm: pdflush Tainted: G        W   
> 2.6.28-11-server #42-Ubuntu

...

> # uname -a
> Linux homer 2.6.28-11-server #42-Ubuntu SMP Fri Apr 17 02:48:10 UTC  
> 2009 i686 GNU/Linux

A lot of fixes have gone into ext4 since 2.6.28 was released, and I
don't know what if any backports of fixes this vendor kernel may have in
it....  I don't remember if we've found the root cause of those
ext4_mb_generate_buddy() errors, perhaps someone else can chime in with
that if they remember better...  :)

> == during reboot to single user mode ==
> : UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> 	(i.e., without -a or -p options)
> fsck died with exit status 4

...

I suppose my general suggestion would be to ask Ubuntu to be sure
they've got all the upstream fixes in their server kernel, or to run a
generic upstream 2.6.29.x stable kernel, which should have most of our
identified bug fixes in it...

-Eric
