From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 1/6] ext4: improve extents status tree trace point
Date: Mon, 1 Sep 2014 22:25:39 -0400
Message-ID: <20140902022539.GR8974@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60014 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaIBCZr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 22:25:47 -0400
Content-Disposition: inline
In-Reply-To: <1407382553-24256-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 07, 2014 at 11:35:48AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit improves the trace point of extents status tree.  We rename
> trace_ext4_es_shrink_enter in ext4_es_count() because it is also used
> in ext4_es_scan() and we can not identify them from the result.
> 
> Further this commit fixes a variable name in trace point in order to
> keep consistency with others.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied to the ext4 tree, thanks.

					- Ted
