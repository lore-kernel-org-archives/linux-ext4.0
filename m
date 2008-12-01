From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH]ext4: fix s_dirty_blocks_counter if block allocation
	failed with nodelalloc
Date: Mon, 1 Dec 2008 16:06:41 +0530
Message-ID: <20081201103641.GA13242@skywalker>
References: <4933BAC2.6080004@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Li Zefan <lizf@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:62396 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYLAKog (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 05:44:36 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id mB1ArNtX165230
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:53:23 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1AbKEk2531542
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:37:20 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB1AatdP019517
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:36:56 +1100
Content-Disposition: inline
In-Reply-To: <4933BAC2.6080004@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 01, 2008 at 07:21:54PM +0900, Akira Fujita wrote:
> ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> If block allocation failed after marking claimed blocks as dirty blocks
> with nodelalloc, we have to subtract these blocks from
> s_dirty_blocks_counter in error handling.
> Otherwise s_dirty_blocks_counter goes wrong so that
> filesystem's free blocks decreases incorrectly.

Why did the block allocation fail ? With delayed allocation ENOSPC
should not happen during block allocation. That would mean we did
something wrong in block reservation.

> 
> This issue was reported as ext4 online defrag's bug by Li Zefan.
> http://marc.info/?l=linux-ext4&m=122697235715170&w=2

-aneesh
