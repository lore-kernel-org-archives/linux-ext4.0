From: Jan Kara <jack@suse.cz>
Subject: Re: Re: [PATCH] ext4: release discard bio after sending discard
 commands
Date: Wed, 2 Aug 2017 10:18:34 +0200
Message-ID: <20170802081834.GC2732@quack2.suse.cz>
References: <20170801090909.GB4215@quack2.suse.cz>
 <1501554568-13815-1-git-send-email-daeho.jeong@samsung.com>
 <CGME20170801022917epcas2p49ee3e7d5ac5cba8746253429888b6d1c@epcms1p4>
 <20170801233138epcms1p4e0d111bd6757201e7df26a281c9d7dd4@epcms1p4>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, "jack@suse.com" <jack@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751214AbdHBISh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 04:18:37 -0400
Content-Disposition: inline
In-Reply-To: <20170801233138epcms1p4e0d111bd6757201e7df26a281c9d7dd4@epcms1p4>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-08-17 23:31:38, Daeho Jeong wrote:
> 
> > > We've changed the discard command handling into parallel manner.
> > > But, in this change, I forgot decreasing the usage count of the bio
> > > which was used to send discard request. I'm sorry about that.
> > > 
> > > Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> > > Fixes: a015434480dc ("ext4: send parallel discards on commit
> > > completions")
>  
> > Why do you think this is needed? submit_bio_wait() consumes the reference
> > that you've got from __blkdev_issue_discard()...
> >  
> >                                                                Honza
> 
> Hi Jan,
> 
> I thought like you, but submit_bio_wait() doesn't consume the reference
> of the bio and the bio cannot be released after the I/O has been completed.
> The caller of submit_bio_wait() should invoke bio_put() in person.
> You can see what we have to do after calling submit_bio_wait() in
> fs/crypto/bio.c.
> 
> Actually, in our device, I can see that the slab memory grows gradually
> because of the unreleased discard bios.

Ah, good point. I had a deeper look now and indeed submit_bio_wait() uses
it's own end_io function which does not drop the bio reference. So I
retract my objection and feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
