From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: (un)lock_kernel() ?
Date: Wed, 04 Apr 2007 10:36:42 -0500
Message-ID: <1175701002.6489.4.camel@shaggy>
References: <alpine.DEB.0.83.0704040853450.28216@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50294 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992933AbXDDPkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Apr 2007 11:40:25 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l34FeMfb019363
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 11:40:22 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l34Fd6ei192548
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 11:39:06 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l34Fd6FH015018
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 11:39:06 -0400
In-Reply-To: <alpine.DEB.0.83.0704040853450.28216@sigma.j-a-k-j.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-04-04 at 08:57 -0400, John Anthony Kazos Jr. wrote:
> Why does ext4_fill_super release the BKL on entry and take it on both 
> normal and abnormal exit? As far as I can see, ext4_fill_super is called 
> by get_sb_bdev, which calls the ->get_sb method without the BKL, and 
> ext4_get_sb calls get_sb_bdev without the BKL. And the ext2 code does not 
> touch the BKL in ext2_fill_super.
> 
> Is the VFS code going to be changed somewhere in the future and it's being 
> anticipated, or is this a bug?

According to Documentation/filesystems/Locking, ->get_sb() is called
with the BKL held, but looking through the code, I'm not able to find
where it is being taken.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
