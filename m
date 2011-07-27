From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 04/11] ext4: let ext4_group_add_blocks() return an
 error code
Date: Tue, 26 Jul 2011 21:49:47 -0400
Message-ID: <20110727014947.GG19851@thunk.org>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311048137-16400-5-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, amir73il@gmail.com,
	tm@tao.ma
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48889 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1G0Btu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:49:50 -0400
Content-Disposition: inline
In-Reply-To: <1311048137-16400-5-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:02:10PM +0800, Yongqiang Yang wrote:
> This patch lets ext4_group_add_blocks() return an error code if it fails,
> so that upper functions can handle error correctly.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, added to the ext4 tree.

					- Ted
