From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond i_size
Date: Wed, 28 Apr 2010 10:10:09 +0530
Message-ID: <87och49oly.fsf@linux.vnet.ibm.com>
References: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50582 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0D1EkW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Apr 2010 00:40:22 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp02.au.ibm.com (8.14.3/8.13.1) with ESMTP id o3S4akAB001414
	for <linux-ext4@vger.kernel.org>; Wed, 28 Apr 2010 14:36:46 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3S4XVRF553100
	for <linux-ext4@vger.kernel.org>; Wed, 28 Apr 2010 14:33:31 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3S4eFoa030423
	for <linux-ext4@vger.kernel.org>; Wed, 28 Apr 2010 14:40:16 +1000
In-Reply-To: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  9 Apr 2010 21:22:28 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Zerrout trick allow us to optimize cases where it is more reasonable
> to explicitly zeroout extent and mark it as initialized instead of
> splitting to several small ones.
> But this optimization is not acceptable is extent is beyond i_size
> Because it is not possible to have initialized blocks after i_size.
> Fsck treat this as incorrect inode size.
> 

With commit c8d46e41bc744c8fa0092112af3942fcd46c8b18 if we set
EXT4_EOFBLOCKS_FL we should be able to have blocks beyond i_size.
May be the zero out path should set the flag instead of doing all these
changes. Zero-out is already complex with all the ENOSPC related
consideration. I guess we should try to keep it simple.

-aneesh
