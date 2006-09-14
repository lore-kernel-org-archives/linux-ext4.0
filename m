From: Avantika Mathur LTC <mathur@us.ibm.com>
Subject: ext4 devel interlock meeting minutes (Sept. 13, 2006)
Date: Thu, 14 Sep 2006 09:20:07 -0700
Message-ID: <45098137.5040809@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:7650 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750974AbWINQUM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Sep 2006 12:20:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8EGK9PL024155
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 12:20:09 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8EGK8cH221488
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 10:20:08 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8EGK8kI016032
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 10:20:08 -0600
Received: from [127.0.0.1] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.82])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k8EGK7UJ015951
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 10:20:08 -0600
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Below are minutes from yesterday's interlock call.
-----

Ext4 Developer Interlock Call: 9/13/06 Meeting Minutes

Attendees: Shaggy(Dave Kleikamp), Suparna Bhattacharya, Jean-Noel, 
Alexadre Ratchov, Badari Pulavarty, Andreas Dilger, Eric Sandeen, 
Avantika Mathur

1. Shaggy has started porting ext4 patches to the current -mm tree.  He 
hopes to have this done in the next few days, and will send out the 
updated series.  Andrew Morton wants to get these patches in soon after 
2.6.19-rc1

2. Ext3 patches are in the -mm tree waiting for 2.6.19-rc1

3. All of Eric's patches seem to be in e2fsprogs. There may be items 
left to fix in e2Image.  Andreas' fixes are also in e2fsprogs

4. Large group descriptor patches: The Bull Team is currently testing 
these patches.  They are also looking at issues with compatibility with 
current on disk filesystems with small group descriptors.

5. Andreas mentioned that resizing may not work past 16 TB, it is 
something that should be addressed for when the 64 bit incompat flag is 
set.

6. Suparna asked about Preallocation support, Shaggy is busy with 
rebasing the ext4 patches and is not able to work on this currently.

7. Andreas will be sending out partial inode patch.  Currently it needs 
a lot of work, but will be looking for feedback and help.

8. The Bull team has been working on a patch to add the 'change 
attribute' to ext3.  This is a counter incremented each time an inode is 
changed.  Alexandre asked about using OS dependent reserved fields in 
the on-disk structure for this counter.  Alexandre will be posting these 
patches today for review.


----
Avantika Mathur
IBM LTC-kernel team

