From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (July 9, 2007)
Date: Mon, 09 Jul 2007 15:00:18 -0700
Message-ID: <4692AFF2.6000304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:60049 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbXGIV74 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 17:59:56 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l69LxsQk025713
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 17:59:54 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l69LxsqG263152
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 15:59:54 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l69LxsKX001102
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 15:59:54 -0600
Received: from [9.47.17.76] (mathur.beaverton.ibm.com [9.47.17.76])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l69Lxr5n000956
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 15:59:53 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: July 9, 2007 Meeting Minutes

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

Attendees:  Mingming Cao, Takashi Sato, Dave Kleikamp, Jose Santos, 
Andreas Dilger, Amit Arora, Suparna Bhattacharya, Aneesh Veetil, Ted 
T'so, Avantika Mathur

EXT4-PATCH-QUEUE

Preallocation and fallocate:
- Amit will first be merging in Andreas' patch to fallocate, which 
allows initialized extents to be the full 32768 blocks.  Uninitialized 
extents are limited to 32767 blocks.  Amit will also add comments to 
this, and have the update patches ready by tomorrow.
- The fallocate patches are already in the -mm tree.  Ted will move the 
fallocate patches to the front of the patch-queue.
- Once Amit has updated the preallocation, we will push fallocate 
patches and the ext4 preallocation patches to Linus' tree.
- Once fallocate patches are merged in mainline, send patches to Ulrich 
for glibc changes.
- Christoph Hellwig thinks there should be a separate system call for 
deallocate functionality. - Mingming discussed an error case in current 
preallocation.  If the entire filesystem is full,  When an uninitialized 
extent is written to, there is no space to store the metadata blocks 
needed to split it into unintialized and initialized extents.  Andreas' 
proposed solution is to fallback to writing zeroes out to the 
preallocated blocks.  This issue can be resolved as a bug fix after 
preallocation is in mainline.
- Mingming asked about implementing preallocation in ext2/3.  It was 
decided that this is not desirable, as it is an advanced change, and our 
current focus is ext4.

Nanosecond Timestamps:
- Negative timestamps: Temporary solution will be to round small 
negative timestamps within a close range to the epoch to zero.  Large 
negative timestamps would be converted to positive.  This can later be 
fixed to have signed timestamps.

Delayed Allocation:
- We will try to push the delalloc feature for ext4 to mainline.
- It is currently below the unstable patch marker in the queue, because 
of possible vfs implementation of delalloc.
- After the rest of the ext4 patches are pushed; then we will work to 
push delalloc.  These can even be included after 2.6.23-rc1, since there 
are no major format changes.
- If later there is a vfs level delalloc implemented, we can then take 
out support for delalloc from within ext4.

Inode Version:
- Trond has requested a flag in the superblock indicating i_version as 
on or off, rather than using a mount option. - Plan is to remove the 
last i_version patch, which supports disabling i_version through a 
mount  option.  Mingming will remove this patch from the path queue.  
The issue can be resolved once the feature is in mainline.

Other:
- Aneesh will resend a patch witha fix to the block reservation; to be 
added to the patch queue.
- Aneesh had ported the mballoc patches to the current patch queue.  The 
patch was too large to send to the mailing list.  He has found some 
issues with the patches, and will work on fixing those before requesting 
review.
- Aneesh suggested adding 'from: author' to each patch to capture who 
the real author of each feature is.

E2FSPROGS
- Now that version 1.40 is out, Ted will focus on merging in the extetns 
support patches, and trying to have full exents support.
- Ted will also start merging other small patches, such as large number 
of subdirectory support, and nanosecond timestamps.
