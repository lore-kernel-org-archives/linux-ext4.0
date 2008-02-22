From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC] Delayed allocation updates
Date: Fri, 22 Feb 2008 12:35:14 -0800
Message-ID: <1203712514.3639.50.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40355 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYBVUf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 15:35:27 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1MKZO1M029360
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:35:24 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MKZOlA241714
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:35:24 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MKZOFZ007252
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:35:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, ext4 patch queue has keeping a set of delayed allocation for a
while. The know todo is add reservation and ordered mode support.

FYI, The base delayed allocation patches are located at
VFS changes:
http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=delalloc-vfs.patch;h=713004ca3f01ae9e7ace289c596ce25901b6c28a;hb=dc9fa932e786df0f2e18402e990926be667484ac

ext4 support:
http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=delalloc-ext4.patch;h=67f8e2802f52e52497a9a8360a1d979bc60c2142;hb=dc9fa932e786df0f2e18402e990926be667484ac


Here is the updates to the delayed allocation patches in the ext4 patch
queue.

- update delayed allocation with current VFS API write_begin/write_end
- general handling  preallocation
- add block reservation to handle ENOSPC error

Patches will follow. compiles, plan to add to the patch later. Comments?

I looked at ordered mode briefly but not entirely clear how that could
be done without a new callback function. Perhaps Alex has some thoughts?


Cheers,
Mingming
