From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [Take2 PATCH 00/10][e2fsprogs] Initial blk64_t capable API calls.
Date: Wed, 21 May 2008 12:53:25 -0500
Message-ID: <20080521175325.18810.25160.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59185 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836AbYEURxr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2008 13:53:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4LHraYx005761
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:53:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHrQOI155494
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:53:26 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4LHrPin009443
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:53:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following series of patches implement API call needed to handle
64-bit block numbers.  Im concentrating mainly in providing the API
call first and if the interfaces are sane, we can go ahead and start
using them in the rest of libext2fs and the user space programs.

I've run checkpatch and make check on each individual patch in the
series so they should be ready to add to the main repository if the
interfaces are acceptable.

-JRS
