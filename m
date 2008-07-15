From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 00/15][e2fsprogs] Initial blk64_t capable API calls.
Date: Tue, 15 Jul 2008 11:50:02 -0500
Message-ID: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59189 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYGOQuG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 12:50:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGo3Qt007347
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:03 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGo3Yx197098
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:03 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGo3MJ030699
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following series of patches implement API call needed to handle
64-bit block numbers.  Im concentrating mainly in providing the API
call first and if the interfaces are sane, we can go ahead and start
using them in the rest of libext2fs and the user space programs.

It also introduces the changes needed in order to for mke2fs to
support larger that 32-bit blocknr devices.

Bitmap dependencies are commented with "/* FIXME-64 */" to make them
easy to find and replace with the new interface.


-JRS
