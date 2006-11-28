From: Avantika Mathur <mathur@us.ibm.com>
Subject: [PATCH 0/3] extents fixes
Date: Mon, 27 Nov 2006 16:08:56 -0800
Message-ID: <1164672536.10750.16.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:19078 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S933577AbWK1AK0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Nov 2006 19:10:26 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAS0APfw031031
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:25 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAS0APan132936
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:25 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAS0AOWb001259
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:25 -0500
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This set of patches is in response to comments to the extents patch
posted in August.  Can these be added to the -mm tree?

[Patch 1/3]
changes instances of
if ((lhs = expression)) {

to the preferred coding style

lhs=expression;
if (lhs) {


[Patch 2/3]
Performs kmalloc to kzalloc conversion.

[Patch 3/3]
Removes all inline keywords


Thanks,
Avantika Mathur
