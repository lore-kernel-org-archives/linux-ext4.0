From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: remove the entry from es tree when bigalloc is
 enabled
Date: Mon, 29 Jul 2013 12:21:51 -0400
Message-ID: <20130729162151.GH11816@thunk.org>
References: <1374795726-28859-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37047 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab3G2QV4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 12:21:56 -0400
Content-Disposition: inline
In-Reply-To: <1374795726-28859-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 26, 2013 at 07:42:06AM +0800, Zheng Liu wrote:
> From: Jan Kara <jack@suse.cz>
> 
> Now in ext4_da_page_release_reservation() we remove the entry from es
> tree if to_release != 0.  But there are two issues.  One is that it is
> wrong when blocksize != pagesize,

The commit description says that this is wrong, but I don't see
anything in the patch which addresses this.  And could you state what
the impact is of this wrongness?

Thanks,

						- Ted
