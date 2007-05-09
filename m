From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (May 7, 2007)
Date: Wed, 09 May 2007 10:02:14 -0700
Message-ID: <4641FE96.6010603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47642 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbXEIRBu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2007 13:01:50 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49H1oXN015985
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 13:01:50 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49H1nQP491964
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 13:01:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49H1nSf021299
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 13:01:49 -0400
Received: from [9.47.16.99] (mathur.beaverton.ibm.com [9.47.16.99])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l49H1nt8021253
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 13:01:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 05/07/2007 Meeting Minutes

Attendees: Mingming Cao, Dave Kleikamp, Ted Ts'o, Aneesh Veetil, Takashi 
Sato, Jose Santos, Avantika Mathur,

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call


Discussed pushing ext4 patches upstream.

- Preallocation Patches: These patches are almost ready to push, once we 
have consensus from all architecture maintainers on the format of the 
system call.  Mingming will help with this.

- Nanosecond Timestamps:  Ted will take a closer look at this patch 
before pushing

- It was proposed to push everything in the ext4 git tree up until the 
unstable patches.  Before pushing these patches, we must run tests on 
the patches and use the check-patches scripts to perform sanity checking.

e2fsprogs:

- Ted recently posted e2fsprogs-1.39-tyt3; which includes patches 
supporting extents.  This is a work in progress.

- Jose used the patches to e2fsprogs sent by Valerie Clement to create 
large filesystems (with >32-bit block numbers)

   -- Ted suggested that these patches be added to e2fsprogs-tyt3, with 
a flag set when in use, indicating that no shared libraries should be used.

- Ted is planning to discontinue use of Mercurial for e2fsprogs, and 
switch entirely to git.  By using git, we can have a stable and 
development branch for e2fsprogs.  This will also reduce the work Ted 
does to create a patch series.

Migration:

- Aneesh looked at the online defragmentation code, and feels it may not 
be usable for migration because it is solely extents based.  Mingming 
pointed out that the new defrag patches also have support for indirect 
mapped blocks, Aneesh will look into these new patches.

- Ted suggested doing the migration through two ioctls, the first 
migrating the inode online via ioctl, and the second using the 
online-defrag ioctl.

Metablock Groups:

- Mingming mentioned that in the metablock group feature, the inode 
metadata is not moved with the rest of the metadata.  Ted will check 
this, as he thought this had been implemented.

- Online resize does not use metablock groups, and is currently limited 
to 2TB.

- Also need to remove sanity checks in the mount code

- Once these issues are fixed, the metablock group feature can be turned 
on by default for ext4 filesysytems

- The extents option will be turned on by default for all ext4 
filesystems with the extents feature enabled.
