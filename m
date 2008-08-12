From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 0/6 ]Ext4 journal credits reservation fixes
Date: Tue, 12 Aug 2008 09:23:10 -0700
Message-ID: <1218558190.6766.37.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40872 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYHLQXa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 12:23:30 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CGPqhN022711
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:25:52 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CGN9Ho211366
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:23:09 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CGN9f5027922
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:23:09 -0400
In-Reply-To: <1217032947.6394.2.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a rework of journal credits fix patch in the ext4 patch queue.
The patch series contains

- patch 1: helper funtions for journal credits calculation and fix the
writepage/write_begin on nonextent files
- patch 2: journal credit fix wirtepahe/write_begin for extents files,
and migration
- patch 3: credit fix for dio, fallocate
-patch 4: rebase ext4_da_writepages_rework patch
- patch 5: credit fix for delalloc writepages
-patch 6: credit fix for defrag


Mingming

