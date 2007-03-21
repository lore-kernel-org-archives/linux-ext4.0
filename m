From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: using sparse to catch endian errors
Date: Wed, 21 Mar 2007 11:16:26 -0500
Message-ID: <1174493786.13386.4.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57633 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbXCUQQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2007 12:16:28 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2LGGR0S010706
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 12:16:27 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2LGGR1Y225974
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 12:16:27 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2LGGQ4a020432
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 12:16:26 -0400
Received: from [9.53.41.164] (dyn95341164.austin.ibm.com [9.53.41.164])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2LGGQWC020387
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 12:16:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On the conference call, I promised to share the syntax for running
sparse to check for endian problems.

I use the alias:

alias make_sparse='make C=2 CF="-D__CHECK_ENDIAN__"'

Then run "make_sparse fs/jbd2/ fs/ext4/"

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
