From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 05/11] ext4: let ext4_group_add_blocks() handle 0
 blocks quickly
Date: Tue, 26 Jul 2011 21:52:44 -0400
Message-ID: <20110727015244.GH19851@thunk.org>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311048137-16400-6-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, amir73il@gmail.com,
	tm@tao.ma
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48893 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1G0Bwq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:52:46 -0400
Content-Disposition: inline
In-Reply-To: <1311048137-16400-6-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:02:11PM +0800, Yongqiang Yang wrote:
> If ext4_group_add_blocks() is called with 0 block, it just return 0.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, added to the ext4 tree.

						- Ted
