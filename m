From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: namei.h: include errno.h
Date: Tue, 25 Dec 2012 18:52:33 +0000
Message-ID: <20121225185233.GW4939@ZenIV.linux.org.uk>
References: <1356372898-21272-1-git-send-email-swarren@wwwdotorg.org>
 <20121225182449.GA7874@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56889 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2LYSwp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Dec 2012 13:52:45 -0500
Content-Disposition: inline
In-Reply-To: <20121225182449.GA7874@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 25, 2012 at 01:24:49PM -0500, Theodore Ts'o wrote:
> On Mon, Dec 24, 2012 at 08:14:58AM -0000, Stephen Warren wrote:
> > This solves:
> > 
> > In file included from fs/ext3/symlink.c:20:0:
> > include/linux/namei.h: In function 'retry_estale':
> > include/linux/namei.h:114:19: error: 'ESTALE' undeclared (first use in this function)
> > 
> > Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Looks good to me.  You might want to add that this commit fixes a
> build failure regression in v3.8-rc1 which was introduced in commit
> b9d6ba94b875.
> 
> Al, you want to take this, since the original commit went in via the
> VFS tree?   Or should we have Jan carry this patch?

Applied, will push later today...
