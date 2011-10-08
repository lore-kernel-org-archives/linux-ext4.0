From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix the wrong comment in ext4_ext_search_right.
Date: Sat, 8 Oct 2011 15:50:52 -0400
Message-ID: <20111008195052.GH7948@thunk.org>
References: <1318001428-3108-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45963 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1JHTuy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 15:50:54 -0400
Content-Disposition: inline
In-Reply-To: <1318001428-3108-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 07, 2011 at 11:30:26PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> With ext4_ext_search_right, the comment is wrong. We returns 0 @phys when
> *logical is the 'largest' allocated block, not smallest. So change it.
> Some other typos are also included.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Applied, thanks.

						- Ted
