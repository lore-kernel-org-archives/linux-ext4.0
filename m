From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use le32_to_cpu for ext4_extent_idx.ei_block in
 ext4_ext_search_left.
Date: Sat, 8 Oct 2011 16:11:33 -0400
Message-ID: <20111008201133.GJ7948@thunk.org>
References: <1318001428-3108-1-git-send-email-tm@tao.ma>
 <1318001428-3108-3-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43540 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1JHULd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 16:11:33 -0400
Content-Disposition: inline
In-Reply-To: <1318001428-3108-3-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 07, 2011 at 11:30:28PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> ext4_extent_idx.e_block is __le32, so use le32_to_cpu when using them
> in ext4_ext_search_left.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

						- Ted
