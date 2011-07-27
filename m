From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 01/11] ext4: prevent parallel resizers by atomic bit
 ops
Date: Tue, 26 Jul 2011 21:38:22 -0400
Message-ID: <20110727013822.GD19851@thunk.org>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311048137-16400-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, amir73il@gmail.com,
	tm@tao.ma
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60549 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab1G0BiZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:38:25 -0400
Content-Disposition: inline
In-Reply-To: <1311048137-16400-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:02:07PM +0800, Yongqiang Yang wrote:
> Before this patch, parallel resizers are allowed and protected by a mutex lock,
> actually, there is no need to support parallel resizer, so this patch prevents
> parallel resizers by atmoic bit ops, like lock_page() and unlock_page() do.
> 
> To do this, the patch removed the mutex lock s_resize_lock from struct ext4_sb_info
> and added a unsigned long field named s_resize_flags which inidicates if there is
> a resizer.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, added to the ext4 patch.

					- Ted
