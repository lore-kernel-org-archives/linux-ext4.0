From: Mingming Cao <cmm@us.ibm.com>
Subject: inode version updates
Date: Wed, 13 Jun 2007 18:02:42 -0700
Message-ID: <1181782962.13428.26.camel@dyn9047017103.beaverton.ibm.com>
References: <466ED042.50401@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kalpak Shah <kalpak@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52986 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbXFNBCu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2007 21:02:50 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l5E0wB61011033
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 20:58:11 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5E12i2f209450
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 19:02:44 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5E12hIx011577
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 19:02:44 -0600
In-Reply-To: <466ED042.50401@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-12 at 09:56 -0700, Avantika Mathur wrote:
> Ext4 Developer Interlock Call: Jun 11, 2007 Meeting Minutes

> i_version:
> - Kalpak will be separating i_version code from his expand-inode-size 
> patch, and merging with the other i_version patches
> 
I took out the i_version code from Kalpak's
ext4_expand_inode_extra_isize.patch. 

http://repo.or.cz/w/ext4-patch-queue.git?
a=blob;f=ext4_i_version_hi_2.patch;h=4519dd6540a78cadd235dad68248456d59c3384c;hb=8b956b5c5ccc3731f23fbce8d036b21f378fbdec

Added Jean noel's inode version VFS patch and Ext4 patches. Now the full
inode version patch series can be found at ext4 patch queue:

# inode verion patch series
# inode versioning is needed for NFSv4

# vfs changes, 64 bit inode->i_version
i_version_update_vfs.patch
# reserve hi 32 bit inode version on ext4 on-disk inode
i_version_hi.patch
# ext4 inode version read/store
ext4_i_version_hi_2.patch
# ext4 inode version update
i_version_update_ext4.patch



Please Ack.

Thanks,
Mingming
