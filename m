From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: remove the entry from es tree when bigalloc is
 enabled
Date: Mon, 29 Jul 2013 19:50:47 +0200
Message-ID: <20130729175047.GA14316@quack.suse.cz>
References: <1374795726-28859-1-git-send-email-wenqing.lz@taobao.com>
 <20130729162151.GH11816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab3G2Ruu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 13:50:50 -0400
Content-Disposition: inline
In-Reply-To: <20130729162151.GH11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-07-13 12:21:51, Ted Tso wrote:
> On Fri, Jul 26, 2013 at 07:42:06AM +0800, Zheng Liu wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > Now in ext4_da_page_release_reservation() we remove the entry from es
> > tree if to_release != 0.  But there are two issues.  One is that it is
> > wrong when blocksize != pagesize,
> 
> The commit description says that this is wrong, but I don't see
> anything in the patch which addresses this.  And could you state what
> the impact is of this wrongness?
  Well, this wrongness actually shouldn't have any real impact - for
blocksize < pagesize the extent tree isn't used while truncate_pagecache()
is running and ext4_truncate() then removes the whole truncated range from
the tree again which hides any problems in
ext4_da_page_release_reservation(). When bigalloc is used, we use the
extent tree during truncate_pagecache() but to_release is always == 1 and
thus the problem doesn't exist.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
