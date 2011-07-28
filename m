From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 09/11] ext4: remove lock_buffer in bclean() and
 setup_new_group_blocks()
Date: Wed, 27 Jul 2011 20:45:24 -0400
Message-ID: <20110728004524.GB3133@thunk.org>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311048137-16400-10-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, amir73il@gmail.com,
	tm@tao.ma
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51605 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab1G1Ap1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 20:45:27 -0400
Content-Disposition: inline
In-Reply-To: <1311048137-16400-10-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:02:15PM +0800, Yongqiang Yang wrote:
> Nobody touchs blocks beyond the filesystem, there is no need to lock
> the buffers.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Added to the ext4 tree, thanks.

						- Ted
