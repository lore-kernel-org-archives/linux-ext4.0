From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 02/11] ext4: prevent a fs with errors from being
 resized
Date: Tue, 26 Jul 2011 21:42:42 -0400
Message-ID: <20110727014242.GE19851@thunk.org>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311048137-16400-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, amir73il@gmail.com,
	tm@tao.ma
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60554 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab1G0Bmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:42:44 -0400
Content-Disposition: inline
In-Reply-To: <1311048137-16400-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:02:08PM +0800, Yongqiang Yang wrote:
> A filesystem with errors is not allowed to being resized, otherwise, it is
> easy to destroy the filesystem.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, added to the ext4 tree.

					- Ted
