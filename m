From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 0/3][e2fsprogs] 64bit IO manager support.
Date: Mon, 03 Mar 2008 10:41:13 -0600
Message-ID: <20080303164113.5557.68102.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43553 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYCCQlO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2008 11:41:14 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m23GfEKd004530
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 11:41:14 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GfEmt176044
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 09:41:14 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GfD45030930
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 09:41:13 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series add support for 64bit blocks to the IO manager
interface.  It add additional read_blk64 and write_blk64 routines to
the struct_io_manager as well as adding 64 bit routines to the unix
and inode io managers.  Coments on whether this approach is right(or
wrong) for adding support for 64bit blocks to e2fsprogs are welcome.

-JRS


