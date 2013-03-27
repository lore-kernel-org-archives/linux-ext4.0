From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Wed, 27 Mar 2013 11:13:40 +0800
Message-ID: <20130327031340.GA9887@gmail.com>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <5149C452.3070206@redhat.com>
 <20130320144523.GF12865@thunk.org>
 <20130326055251.GA17165@gmail.com>
 <20130326203403.GE2082@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61634 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3C0C57 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2013 22:57:59 -0400
Received: by mail-pa0-f50.google.com with SMTP id bg2so1903728pad.23
        for <linux-ext4@vger.kernel.org>; Tue, 26 Mar 2013 19:57:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130326203403.GE2082@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 09:34:03PM +0100, Jan Kara wrote:
> On Tue 26-03-13 13:52:51, Zheng Liu wrote:
> > Sorry for the late reply.
> > 
> > On Wed, Mar 20, 2013 at 10:45:23AM -0400, Theodore Ts'o wrote:
> > > On Wed, Mar 20, 2013 at 09:14:42AM -0500, Eric Sandeen wrote:
> > > > 
> > > > As an aside, is there any reason to have "dioread_nolock" as an option
> > > > at this point?  If it works now, would you ever *not* want it?
> > > > 
> > > > (granted it doesn't work with some journaling options etc, but that
> > > > behavior could be automatic, w/o the need for special mount options).
> > > 
> > > The primary restriction is that diread_nolock doesn't work when fs
> > > block size != page size.  If your proposal is that we automatically
> > > enable diread_nolock when we can use it safely, that's definitely
> > > something to consider for the next merge window.
> > 
> > Yes, I also think we can automatically enable dioread_nolock because it
> > brings us some benefits.
>   But isn't there also some overhead due to buffered writes having to go
> through uninit->init conversion?

Yeah, in my test, the IOPS will decrease after dioread_nolock enables.
But the latency of dio will also descrease.  Honestly I don't test
buffered IO.  So I will test this case and post the result later.  IMO,
this is a tradeoff that we want to improve latency or get a better
throughput.


> Plus there's this potential deadlock in
> dioread_nolock code (http://www.spinics.net/lists/linux-ext4/msg36569.html)
> which I'm not sure how to fix yet...

Yes, we need to fix this bug first.

> 
> > BTW, I think there is an minor improvement for dio overwrite codepath
> > with indirect-based file.  We don't need to take i_mutex in this
> > condition just as we have done for extent-based file.  If a user mounts
> > a ext2/3 file system with a ext4 kernel modules, he/she could get a
> > lower latency.  But it seems that it would break dio semantic in ext2/3.
> > Currently in ext2/3 if we issue a overwrite dio and then issue a read
> > dio.  We will always read the latest data because we wait on i_mutex
> > lock.  But after parallelizing overwite dio, this semantic might breaks.
> > I re-read this doc but it seems that it doesn't describe this case.  Do
> > we need to keep this semantic?
>   I'm not sure but also I don't think it's important to optimize that
> special case.

Thanks for the comment.  I am really not sure whether it is worth.  Let
me test the performance w/ and w/o dioread_nolock first. :-)

Regards,
                                                - Zheng
