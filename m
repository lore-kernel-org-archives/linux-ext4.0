From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Ext4 Punch Hole Change Summary v6->v7
Date: Sat, 07 May 2011 16:53:50 -0700
Message-ID: <4DC5DB8E.7050805@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33078 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab1EGXyA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 May 2011 19:54:00 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p47NYHYp031469
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:34:17 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p47NrvLm109758
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:53:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p47Nrvnh020114
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:53:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

This is an updated copy of punch hole that has the while loop 
optimization for ext4_ext_remove_space (in patch 3/5).  The optimization 
limits the tree searching to only the extents that are to be removed 
instead of searching the entire tree.

Also, I updated my base code to the latest copy of the ext4 code, and 
one of the punch hole test cases found a null pointer bug when trying to 
create a directory when the disk is full.  It is not directly related to 
punch hole, so I put it in a separate patch.  Jan, this looks like it 
may have been related to the "[PATCH 1/2] ext4: Fix fs corruption when 
make_indexed_dir() fails" patch.  Would you mind taking a look at it and 
giving it your OK if everything looks good?  Thx!

Allison Henderson
