Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726914AbfAQJf5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Jan 2019 04:35:57 -0500
Date: Thu, 17 Jan 2019 10:35:55 +0100
From: Jan Kara <jack@suse.cz>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Phillip Potter <phil@philpotter.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "cc: Matthew Wilcox" <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
Message-ID: <20190117093555.GC9378@quack2.suse.cz>
References: <20190102174736.GB29127@quack2.suse.cz>
 <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz>
 <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
 <20190115180156.GB6310@bombadil.infradead.org>
 <CAHk-=whor678X0A4Mz95KSoG2f0O_F8a5PEQNXLqPxDehs+7Fg@mail.gmail.com>
 <20190116120754.GF26069@quack2.suse.cz>
 <CAA=Fs0mrvr2mErpG-DBLW7Kg2xUXU_1+J4Eg4Fi+T=x5sH7BDQ@mail.gmail.com>
 <20190116165147.GI26069@quack2.suse.cz>
 <CAOQ4uxipOf-MH3eC8fbV6ZrF63thq0+PyBpoNMzv=WWF_=vs2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxipOf-MH3eC8fbV6ZrF63thq0+PyBpoNMzv=WWF_=vs2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-01-19 18:56:17, Amir Goldstein wrote:
> On Wed, Jan 16, 2019 at 6:51 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 16-01-19 16:34:36, Phillip Potter wrote:
> > > Dear Jan,
> > >
> > > I am happy to rework the patches, all fair comment. Slight problem
> > > being my computer is in a box right now as I've just moved house. I
> > > will get this done in the next few days if that's ok?
> >
> > Sure, no problem. Patches won't make it in this release cycle so we have
> > like three weeks to get them ready for the next merge window.
> >
> 
> Also, and Jan will correct me if I am wrong.
> I think that reworking only the common and ext2 patches would
> be sufficient for this cycle.

Yes, that's also true.

> You can prepare the rest of the patches for next cycle after
> the common patch has landed.

Correct, since the plan is for these to land through other maintainers'
trees. But still it would be nice if we had them earlier just to see of
other maintainers don't seriously oppose the idea. To that end it is
probably good to reference the discussion with Linus in the cover letter
and the email with common infrastructure, explaining why converting to
common defines instead of keeping filesystem specific ones was done.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
