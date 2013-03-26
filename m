From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Tue, 26 Mar 2013 21:34:03 +0100
Message-ID: <20130326203403.GE2082@quack.suse.cz>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <5149C452.3070206@redhat.com>
 <20130320144523.GF12865@thunk.org>
 <20130326055251.GA17165@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab3CZUeI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 16:34:08 -0400
Content-Disposition: inline
In-Reply-To: <20130326055251.GA17165@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 26-03-13 13:52:51, Zheng Liu wrote:
> Sorry for the late reply.
> 
> On Wed, Mar 20, 2013 at 10:45:23AM -0400, Theodore Ts'o wrote:
> > On Wed, Mar 20, 2013 at 09:14:42AM -0500, Eric Sandeen wrote:
> > > 
> > > As an aside, is there any reason to have "dioread_nolock" as an option
> > > at this point?  If it works now, would you ever *not* want it?
> > > 
> > > (granted it doesn't work with some journaling options etc, but that
> > > behavior could be automatic, w/o the need for special mount options).
> > 
> > The primary restriction is that diread_nolock doesn't work when fs
> > block size != page size.  If your proposal is that we automatically
> > enable diread_nolock when we can use it safely, that's definitely
> > something to consider for the next merge window.
> 
> Yes, I also think we can automatically enable dioread_nolock because it
> brings us some benefits.
  But isn't there also some overhead due to buffered writes having to go
through uninit->init conversion? Plus there's this potential deadlock in
dioread_nolock code (http://www.spinics.net/lists/linux-ext4/msg36569.html)
which I'm not sure how to fix yet...

> BTW, I think there is an minor improvement for dio overwrite codepath
> with indirect-based file.  We don't need to take i_mutex in this
> condition just as we have done for extent-based file.  If a user mounts
> a ext2/3 file system with a ext4 kernel modules, he/she could get a
> lower latency.  But it seems that it would break dio semantic in ext2/3.
> Currently in ext2/3 if we issue a overwrite dio and then issue a read
> dio.  We will always read the latest data because we wait on i_mutex
> lock.  But after parallelizing overwite dio, this semantic might breaks.
> I re-read this doc but it seems that it doesn't describe this case.  Do
> we need to keep this semantic?
  I'm not sure but also I don't think it's important to optimize that
special case.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
