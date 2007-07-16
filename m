From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue updated
Date: Mon, 16 Jul 2007 07:56:57 -0700
Message-ID: <1184597817.4005.43.camel@localhost.localdomain>
References: <1183275408.4010.124.camel@localhost.localdomain>
	 <20070710163025.9db582f8.akpm@linux-foundation.org>
	 <1184573972.4005.21.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:56354 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbXGPO5E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jul 2007 10:57:04 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6GEv1Rt025540
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 10:57:01 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6GEuvMV258586
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 08:56:59 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6GEutX8009835
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 08:56:56 -0600
In-Reply-To: <1184573972.4005.21.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have updated ext4 patch queue.  The updated ext4 patch queue includes
updated patches from Kalpak, Jose, and me.  It now addresses most of
review comments from Andrew, including checkpatch.pl complains, add
"diffstat"  etc. Also I noticed Amit has updated fallocate() patch
series as well.

The patches that still need more attentions are:

ext4-journal_chksum-2.6.20.patch
jbd-stats-through-procfs_fix.patch
and inode version patch series


Thanks,
Mingming Cao
