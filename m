From: Josef Bacik <jbacik@redhat.com>
Subject: Re: Ordered mode rewrite patch
Date: Mon, 14 Apr 2008 13:50:35 -0400
Message-ID: <20080414175034.GB20924@unused.rdu.redhat.com>
References: <20080408121149.GB6901@duck.suse.cz> <20080411184258.GA2757@unused.rdu.redhat.com> <20080414174722.GG15824@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Nathan Grennan <jack@cygnusx-1.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYDNR7N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2008 13:59:13 -0400
Content-Disposition: inline
In-Reply-To: <20080414174722.GG15824@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 14, 2008 at 07:47:22PM +0200, Jan Kara wrote:
>   Hi Josef,
> 
> On Fri 11-04-08 14:42:58, Josef Bacik wrote:
> > On Tue, Apr 08, 2008 at 02:11:49PM +0200, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   attached is a jumbo patch that reverses locking order of transaction
> > > start and page lock in ext3 and rewrites handling of ordered data mode in
> > > JBD and ext3. Note that the patch will break compilation of ext4 and OCFS2.
> > > The patch survives LTP run on my test machine so it shouldn't eat your data
> > > immediately but bugs are of course possible...
> > >   I'm very interested in any results (both positive and negative) you could
> > > get with it :). Thanks for testing it.
> > > 
> > > 									Honza
> > I just hit a problem with your patch.  In journal_destroy() we do a
> > iput(journal->j_inode) and then kfree the journal, so when the iput comes back
> > into journal_release_jbd_inode we are doing a use after free which in my case
> > resulted in a panic.  I was going to fix it but I figure since this is still in
> > transit you would have to just rewrite it so I'm not going to attach one, just
> > giving you a heads up.  Let me know if my explanation wasn't clear enough.
>   Thanks for letting me know. But I don't quite get it:
> journal_destroy() does:
>         if (journal->j_inode)
>                 iput(journal->j_inode);
>         if (journal->j_revoke)
>                 journal_destroy_revoke(journal);
>         kfree(journal->j_wbuf);
>         kfree(journal);
> }
> 
>   iput() will eventually call generic_forget_inode() which calls
> clear_inode() in which we do journal_release_jbd_inode(). But at that
> moment journal still exists to I don't see any use after free... But
> possibly there could be some other inode in the inode list but which one is
> it?
>

Hmm sorry in my pretend world iput goes off and does its thing and everything
keeps going...  You are right it cant be that inode, but I definitely got a
panic so there must be some other inode in the inode list that is getting freed
after the journal is freed.  Thanks much,

Josef 
