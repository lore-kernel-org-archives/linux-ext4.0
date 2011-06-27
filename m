From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix incorrect error msg in ext4_ext_insert_index
Date: Mon, 27 Jun 2011 15:36:45 -0400
Message-ID: <20110627193645.GE2729@thunk.org>
References: <1308104726-5112-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51538 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab1F0Tgy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 15:36:54 -0400
Content-Disposition: inline
In-Reply-To: <1308104726-5112-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 15, 2011 at 10:25:26AM +0800, Robin Dong wrote:
> In function ext4_ext_insert_index when eh_entries of curp is
> bigger than eh_max, error messages will be printed out, but the content
> is about logical and ei_block, that's incorret.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Added to the ext4 tree, thanks!!

					- Ted
