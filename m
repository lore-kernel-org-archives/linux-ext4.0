From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][e2fsprogs][mke2fs] fix FLEX_BG offset
Date: Thu, 3 Jul 2008 06:55:53 -0500
Message-ID: <20080703065553.53c35979@gara>
References: <486C8BEE.5030200@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	=?UTF-8?B?RnLDqWTDqXJpYyBC?= =?UTF-8?B?b2jDqQ==?=
	<frederic.bohe@bull.net>,
	SOLOFO RAMANGALAHY <Solofo.Ramangalahy@bull.net>,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
To: Celine Bourde <celine.bourde@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33189 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYGCLzz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:55 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m63BtrS0027812
	for <linux-ext4@vger.kernel.org>; Thu, 3 Jul 2008 07:55:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m63BtsqL210966
	for <linux-ext4@vger.kernel.org>; Thu, 3 Jul 2008 07:55:54 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m63Btrqv002386
	for <linux-ext4@vger.kernel.org>; Thu, 3 Jul 2008 07:55:53 -0400
In-Reply-To: <486C8BEE.5030200@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 03 Jul 2008 10:21:02 +0200
Celine Bourde <celine.bourde@bull.net> wrote:

> This patch resolves the offset problem of the flex_bg
> option when you use mke2fs tool.
> 
> For example, if you type mkfs.ext4 -I256 -O flex_bg -G32 -E test_fs <device>
> and look dumpe2fs <device> result you will see an offset problem.
> 
> Group 0: (Blocks 0-32767)
> Primary superblock at 0, Group descriptors at 1-5
> Reserved GDT blocks at 6-1024
> Block bitmap at 1025 (+1025), Inode bitmap at 1058 (+1058)
> Inode table at 1090-1601 (+1090)
> 0 free blocks, 8181 free inodes, 2 directories
> Free blocks:
> Free inodes: 12-8192
> 
> Inode bitmap must start at 1025 + 32 = 1057
> In all flexbg groups, the block between the last block bitmap and the 
> first inode
> bitmap (metatdata) is not used, which introduced a hole.
> 
> This patch corrects it.
> You have to apply it on e2fsprogs (mke2fs 1.41-WIP (17-Jun-2008)) master 
> branch.
> 
> Celine Bourde.

Acked-by: Jose R. Santos <jrs@us.ibm.com>

-JRS
