From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: [PATCH] ext4: dir inode reservation V3
Date: Tue, 13 Nov 2007 17:09:46 +0300
Message-ID: <4739B02A.2000209@gmail.com>
References: <4739B0C0.3060907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: coyli@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-2.sun.com ([192.18.6.24]:46776 "EHLO
	gmp-eb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXKMOKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2007 09:10:10 -0500
In-reply-to: <4739B0C0.3060907@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hmm. so you trade 265% degradation of creation for 40% improvement of unlink?

thanks, Alex

Coly Li wrote:
> 			normal ext4			ext4 with dir inode reservation
> 	mount options:	-o data=writeback		-o data=writeback,dir_ireserve=low
> 	Create dirs:	real    0m49.101s		real    2m59.703s
> 	Create files:	real    24m17.962s		real    21m8.161s
> 	Unlink all:	real    24m43.788s		real    17m29.862s
> Creating dirs with dir inode reservation is slower than normal ext4 as predicted, because allocating
> directory inodes in non-linear order will cause extra hard disk seeking and block I/O. Creating
> files with dir inode reservation is 13% faster than normal ext4. Unlink all the directories and
> files is 29.2% faster as expected.
> When number of directories is increased, the performance improvement will be more considerable. More
> benchmark result will be posted here if necessary, because I need more time to run more test cases.
