From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: finding the author of the patches in ext4-patch-queue
Date: Wed, 04 Jul 2007 10:37:01 +0530
Message-ID: <468B2AF5.5060207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:61212 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXGDFIy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2007 01:08:54 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l645U6cW149236
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 15:30:19 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l645B1Ij179690
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 15:11:03 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l64574ak020956
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 15:07:04 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

With respect to ext4-patch-queue it is kind of difficult to find who wrote the patch.
I guess we can solve this by adding From: < author name > in the patches. This will make sure
when the patches get applied to linus tree we have the right author.

with the below diff to noextent_mount option patch i get the below history when applying the patches
using stgit via stgit --import --series 


diff --git a/ext4_noextent_mount_opt.patch b/ext4_noextent_mount_opt.patch
index c349afb..e9a8d6f 100644
--- a/ext4_noextent_mount_opt.patch
+++ b/ext4_noextent_mount_opt.patch
@@ -1,3 +1,4 @@
+From: Mingming Cao <cmm@us.ibm.com>
 Add a mount option to turn off extents.
 
 Signed-off-by: Mingming Cao <cmm@us.ibm.com>

$ git log 
commit f89bcb4ca03dde8b12d3c722483aae84c3d2072d
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Wed Jul 4 10:32:19 2007 +0530

    Add a mount option to turn off extents.
    
    Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Without the change: I get below

commit 4a4f228f99e263767fe5b395cdb843a5c5d083fe
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Jul 4 10:05:19 2007 +0530

    Turn on extents feature by default in ext4 filesystem. User could use
    -o noextents to turn it off.
    
    Signed-off-by: Mingming Cao <cmm@us.ibm.com>


-aneesh
