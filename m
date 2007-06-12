From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (June 11, 2007)
Date: Tue, 12 Jun 2007 09:56:34 -0700
Message-ID: <466ED042.50401@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54734 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869AbXFLQ4c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2007 12:56:32 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5CFrjcR024768
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 11:53:45 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5CGuVmU557880
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 12:56:31 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5CGuVxo015061
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 12:56:31 -0400
Received: from [9.47.16.99] (mathur.beaverton.ibm.com [9.47.16.99])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5CGuULY014832
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 12:56:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: Jun 11, 2007 Meeting Minutes

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

Attendees: Mingming Cao, Ted T'so, Dave Kleikamp, Takashi Sato, Suparna 
Bhattacharya, Jose Santos, Andreas Dilger, Avantika Mathur

EXT4 GIT TREE
- We need to start preparing patches to be moved upstream.  This 
includes final review and formatting comments properly for merging to 
Linux. 

- For those with access to the git tree, they can modify their patches 
directly.  Otherwise this will be done on the mailing list, and Ted, 
Mingming or Shaggy will update the tree.

- Ted suggested that we run the checkpatch.pl script (that was posted on 
lkml and is now in mainline) against all new patches in the git tree.  
The output can then be posted on the ext4 mailing list, and the authors 
can fix any problems with their patches.  He encourages everyone to run 
the script on patches before posting, to prevent comments on small issues.

- Each time the git tree is updated a set of tests is automatically run 
to test for regressions.

- The plan is to move as many patches as possible to mainline once 
2.6.22 is released

PATCHES
- Extents on by default:  Ted suggested updating this patch, so that 
extents feature is on by default only if the extents incompat feature is 
turned on.  It was decided that for EXT4DEV, extents will always be on 
by default, and when we move to Ext4, extents will only be defaulted 
with the feature is turned on.  Another choice is to make extents a 
config option.

- Mingming will add Jose's JBD2 patches to the patch queue, as long as 
there are no remaining comments on the list.

- Preallocation: The fallocate system call has been finalized, with no 
remaining issues.  David Chinner had said he would write a man page for 
the system call; this should be added to the patches.

- Online Defragmentation: Takashi will send out his new patches this 
weekend.

- delayed allocation: These patches are ready to move to mainline, 
except for an outstanding request from Andrew for more comments.  
Mingming will ping Alex to see what the status is.

- Journal Checksumming: These patches are broken on ppc machines. 
Andreas is working on fixing the endian-ness of the checksums.

- Uninitialized Block Group: Andreas will post an inter-diff to the 
ported patches Avantika posted.

- nanosecond timestamp and subdir-limit patches are ready to push upstream.

i_version:
- Kalpak will be separating i_version code from his expand-inode-size 
patch, and merging with the other i_version patches

- Mingming will respond to last week's meeting minutes asking Trond what 
he thinks of implementing this feature in the VFS.  If Trond is ok with 
the feature as is, it will be ready to push.

- Steve French who works on Samba and CIFS has shown interest in this 
feature, particularly in having it exported to userspace (preferrably 
not using xattrs).


E2fsprogs:
- Ted plans to get 1.40 out soon.  He will then move the tree to git, 
and work to get all of the extents patches integrated.

- Mingming will be rebasing and re-ordering the git tree, based on 
today's discussions.
