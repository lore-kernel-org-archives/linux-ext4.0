From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH] ext4: handle fast symlink properly with inline_data
Date: Mon, 17 Feb 2014 20:52:31 -0500
Message-ID: <20140218015231.GF26580@thunk.org>
References: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ian Nartowicz <claws@nartowicz.co.uk>,
	Tao Ma <tm@tao.ma>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59245 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaBRBwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Feb 2014 20:52:39 -0500
Content-Disposition: inline
In-Reply-To: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 13, 2014 at 03:07:17PM +0800, Zheng Liu wrote:
> 
> I am not sure whether or not we need to enable inline_data for a fast
> symlink inode.  Obviously, it brings a benefit that after enabling
> inline_data feature for a fast symlink we can get more space to store
> the path.  But it seems that the original patch doesn't want to do this
> Another solution for fixing this bug is to disable inline_data for a
> fast symlink.  Any comment?

Well, if we are using inline data, and we have a symlink which is
longer than 60 bytes, but less than extra space available for an
inline data, it seems like a good thing to support.

The downside is that it is a bit more complication to add the kernel's
code in both the kernel as well as e2fsprogs, but it doesn't seem that
bad.

So I don't have any objections to adding this functionality.  What do
other folks think?

						- Ted
