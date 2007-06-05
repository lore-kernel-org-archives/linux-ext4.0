From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (June 4, 2007)
Date: Tue, 05 Jun 2007 11:42:03 -0700
Message-ID: <4665AE7B.4010409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:55536 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXFESmF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 14:42:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l55IbjXK009161
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 14:37:45 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55Ig1XL196610
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 12:42:01 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55Ig1XT021328
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 12:42:01 -0600
Received: from [9.47.16.99] (mathur.beaverton.ibm.com [9.47.16.99])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l55Ig0E1021266
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 12:42:01 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Below are minutes from yesterday's interlock call

Ext4 Developer Interlock Call: June 4, 2007 Meeting Minutes

Attendees: Mingming Cao, Dave Kleikamp, Jean-Pierre Dion, Jean Noel 
Cordenner, Akira Fujita, Jose Santos, Badari Pulavarty, Ted Ts'o, 
Andreas Dilger, Avantika Mathur

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

Ext4 Patch Queue Status:
- The first four bug-fix patches in the ext4 git tree have been accepted 
into Linus' tree. Once 2.6.22-rc4 is out, the ext4 tree will be updated 
with these patches removed.


Inode Versioning Patches:
- There was a lot of discussion about the different requirements and 
plans for this feature.

- NFSv4 requires a 64-bit counter which is updated on every file change 
including metadata updates. unsure sure if it should be updated on atime 
updates.  The counter is only checked for inequality.  The current 
patches by Jean Noel fulfill these requirements.

- Andreas explained Lustre's requirements which are a superset of what 
is required by NFSv4. Every time an operation is executed on a file, the 
counter is updated by a specific value.  The counter is globally unique 
on the entire filesystem.  Andreas said they can use the current 
patches, and build upon them with their own patches for their purposes.

- The current patches use the i_version field in the vfs inode for the 
counter, and all updates to the field are implemented in ext4 code.  
Jean Noel will ask Trond if these patches are ok, or if he would prefer 
the the updates to be implemented at the vfs layer (if it is possible).  
This may make it easier for other filesystems to start using the feature.  

- Ted suggested having a flag in the superblock for i_version, with an 
additional option of having a global counter for Lustre's requirements.  
i_version would be on by default, but give users who do not use the 
feature the option to turn it off and avoid any performance impact.

- Andreas will ask Kalpak to separate the i_version specific changes 
from his expand-inode-size patch, and merge these changes with Jean 
Noel's patches.  

- The i_version is being reset in the ext4_quota_write() function.  Jean 
Noel does not think that this needs to be changed, Andreas and Mingming 
felt that resetting the counter at this place did not make sense.  We 
will keep the patch unchanged, unless there are any

- Once Kalpak's patches are updated and the patches are ok for NFSv4, 
the plan is to post the patches and if there are no issues, push them to 
Linus' tree.


E2fsprogs:
- Ted plans to push e2fsprogs-1.40 this week, so any bug fixes will be 
available to distros.  Ted would like to get the extents capability into 
mainline soon as well.  

- Currently there are many patches to e2fsprogs, Ted hopes to start 
merging these to mainline.

- Valerie is working on patches to e2fsprogs for supporting 64-bit block 
numbers.  Ted is very interested in seeing the direction of these 
patches and strongly encourages Valerie to post her work in progress 
patches soon.


Uninitialized Block Groups:
- Avantika started porting Andreas' uninitialized block group kernel and 
e2fsprogs patches, but ran into problems in testing, with e2fsprogs.  
She will post the patches to the list for further review.
