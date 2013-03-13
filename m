From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][dioread_nolock] blocked for more than 120s when we run
 xfstests #269
Date: Wed, 13 Mar 2013 12:04:26 +0100
Message-ID: <20130313110426.GD29730@quack.suse.cz>
References: <20130307124054.GE2800@gmail.com>
 <20130307151140.GF6723@quack.suse.cz>
 <20130308135222.GA2768@gmail.com>
 <20130311163041.GL29799@quack.suse.cz>
 <20130313091511.GB29730@quack.suse.cz>
 <20130313105233.GB12012@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3CMLEa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 07:04:30 -0400
Content-Disposition: inline
In-Reply-To: <20130313105233.GB12012@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-03-13 18:52:33, Zheng Liu wrote:
> On Wed, Mar 13, 2013 at 10:15:11AM +0100, Jan Kara wrote:
> [snip]
> > > > I post the sysrq-w output here.  But IMHO it is not very useful.  So I
> > > > also post the sysrq-t output.
> > >   Heh, curious. Thanks for the data. So worker thinks there's nothing to do
> > > but inode has elevated i_ioend_count... Maybe we leaked ioend somewhere.
> > > I'll check the code when I have time.
> >   Ah, I think I see what's going on.
> > a) Code in ext4_ext_direct_IO() is racy wrt iocb->private handling (that
> >    can get cleared concurrently from ext4_end_io_dio()).
> 
> Thanks for tracing this problem.  But I am still confused that iocb is
> allocated on stack in do_sync_write(), and is allocated from slab in
> ioctx_alloc().  You mean iocb in ext4_ext_direct_IO and ext4_end_io_dio
> is the same one?
  Yes, it is.

> Then this iocb could be changed concurrently, and we are blocked for more
> than 120s.  I must miss something.
  Well, the hang results from direct IO code forgetting to call
ext4_free_io_end() in some (likely error recovery) path. So
inode->i_ioend_count remains elevated and we never finish waiting in
ext4_evict_inode(). How that forgotten ext4_free_io_end() really happens
isn't 100% clear to me but I really suspect something with concurrent iocb
modification goes wrong...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
