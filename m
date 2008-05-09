From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 0/9][e2fsprogs] Initial blk64_t capable API calls.
Date: Fri, 09 May 2008 11:39:28 -0500
Message-ID: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:45933 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYEIQjN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 12:39:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GZx4j025393
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:35:59 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49GcxSU181984
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:04 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49GcwdV016030
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:38:59 -0600
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
