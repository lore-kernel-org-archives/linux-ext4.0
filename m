From: Mingming Cao <cmm@us.ibm.com>
Subject: Ext4 patch queue updated(2.6.23-rc8)
Date: Wed, 26 Sep 2007 18:36:33 -0700
Message-ID: <1190856993.4517.33.camel@localhost.localdomain>
References: <1189643439.4935.30.camel@localhost.localdomain>
	 <46E95011.7040309@bull.net>
	 <1189717301.3751.11.camel@localhost.localdomain>
	 <1189796613.3841.14.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Christoph Lameter <clameter@sgi.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46553 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXI0Bgg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 21:36:36 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8R1aZcQ012596
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 21:36:35 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8R1aZdP563154
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 21:36:35 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8R1aY0Y008322
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 21:36:35 -0400
In-Reply-To: <1189796613.3841.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

http://repo.or.cz/w/ext4-patch-queue.git

Changes

+ Add large block support back, 
updated patches to fix rec_len overflow issue with 64k blk size from Jan
Kara

split ext234_enlarge_blocksize.patch to three patches, one for each
filesystem type


Fix compile warning with jbd-stats-through-procfs


split jbd_kmalloc_kzalloc.patch into two patches for ext3/jbd and
ext4/jbd2 to sync with what in mm tree


+Add jbd2-fix-commit-code-to-properly-abort-journal.patch from Jan kara

+Added New patch set :Introduce le32_t and le16_t, from Aneesh
