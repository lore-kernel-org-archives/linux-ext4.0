From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix a bug when we try to open a file with
 O_TMPFILE flag
Date: Mon, 22 Jul 2013 15:18:08 +0200
Message-ID: <20130722131808.GD23658@quack.suse.cz>
References: <1374339227-9382-1-git-send-email-wenqing.lz@taobao.com>
 <20130722130737.GC23658@quack.suse.cz>
 <20130722131406.GA2895@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab3GVNSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Jul 2013 09:18:11 -0400
Content-Disposition: inline
In-Reply-To: <20130722131406.GA2895@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 22-07-13 21:14:07, Zheng Liu wrote:
> Hi Jan,
> 
> On Mon, Jul 22, 2013 at 03:07:37PM +0200, Jan Kara wrote:
> > On Sun 21-07-13 00:53:47, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > When we try to open a file with O_TMPFILE flag, we will trigger a bug.
> > > The root cause is that in ext4_orphan_add() we check ->i_nlink == 0 and
> > > this check always fails because we set ->i_nlink = 1 in
> > > inode_init_always().  We can use the following program to trigger it:
> [...]
> > > Here we couldn't call clear_nlink() directly because in d_tmpfile() we
> > > will call inode_dec_link_count() to decrease ->i_nlink.  So this commit
> > > tries to call d_tmpfile() before ext4_orphan_add() to fix this problem.
> >   Thanks the patch looks good. I've added the patch to my tree and will
> > push it to Linus soon.
> 
> Thanks for your review.  Ted has pick it up and Linus has pulled the
> patch.  Sorry, I forgot to remind you.
> 
> http://www.gossamer-threads.com/lists/linux/kernel/1750649
  Yeah, I've just noticed when I updated my tree. No problem.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
