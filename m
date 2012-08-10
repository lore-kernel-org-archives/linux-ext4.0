From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Date: Fri, 10 Aug 2012 08:29:45 -0700
Message-ID: <CAFR8uedP7pGm+KbW4q0fR3L1GS6GwG0yAGUDBsJbrTfKNHnWag@mail.gmail.com>
References: <201207301514247032532@gmail.com>
	<20120730214213.GF2877@dastard>
	<201207310855556258267@gmail.com>
	<20120731011457.GO2877@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: majianpeng <majianpeng@gmail.com>, Neil Brown <neilb@suse.de>,
	axboe <axboe@kernel.dk>, "konrad.wilk" <konrad.wilk@oracle.com>,
	"chris.mason" <chris.mason@fusionio.com>,
	viro <viro@zeniv.linux.org.uk>, tytso <tytso@mit.edu>,
	"adilger.kernel" <adilger.kernel@dilger.ca>,
	shaggy <shaggy@kernel.org>, mfasheh <mfasheh@suse.com>,
	jlbec <jlbec@evilplan.org>, bpm <bpm@sgi.com>,
	elder <elder@kernel.org>,
	jfs-discussion <jfs-discussion@lists.sourceforge.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	xfs <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-raid <linux-raid@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45128 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab2HJP3q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2012 11:29:46 -0400
In-Reply-To: <20120731011457.GO2877@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ Resending in plain text... sorry for the duplicate ]

Hi,

On Mon, Jul 30, 2012 at 6:14 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jul 31, 2012 at 08:55:59AM +0800, majianpeng wrote:
> > On 2012-07-31 05:42 Dave Chinner <david@fromorbit.com> Wrote:
> > >On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> > >> When exec bio_alloc, the bi_rw is zero.But after calling
> > >> bio_add_page,
> > >> it will use bi_rw.
> > >> Fox example, in functiion __bio_add_page,it will call
> > >> merge_bvec_fn().
> > >> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> > >> >> if ((bvm->bi_rw & 1) == WRITE)
> > >> >> return biovec->bv_len; /* always allow writes to be mergeable */
> > >
> > >So if bio_add_page() requires bi_rw to be set, then shouldn't it be
> > >set up for every caller? I noticed there are about 50 call sites for
> > >bio_add_page(), and you've only touched about 10 of them. Indeed, I
> > >notice that the RAID0/1 code uses bio_add_page, and as that can be
> > >stacked on top of RAID456, it also needs to set bi_rw correctly.
> > >As a result, your patch set is nowhere near complete, not does it
> > >document that bio_add_page requires that bi_rw be set before calling
> > >(which is the new API requirement, AFAICT).
> > There are many place call bio_add_page and I send some of those. Because
> > my abilty, so I only send
> > some patchs which i understand clearly.
>
> Sure, but my point is that there is no point changing only a few and
> ignoring the great majority of callers. Either fix them all, fix it
> some other way (e.g. API change), or remove the code from the RAID5
> function that requires it.

A while back, we tried to address this by changing the alloc functions to
take rw argument and set it (as per Jens suggestion). I guess the patch did
not make it in. Please check:

https://lkml.org/lkml/2011/7/11/275

and the follow ups. If needed, I can dust up that patch and resend it.

>

<snip>

>
> It's entirely possible that when bi_rw was added to struct
> bvec_merge_data, the person who added it was mistaken that bi_rw was
> set at this point in time when in fact it never has been. Hence it's
> presence and reliance on it would be a bug.
>
> That's what I'm asking - is this actually beneificial, or should it
> simply be removed from struct bvec_merge_data? Data is needed to
> answer that question....

There are cases where we found it really beneficial to know the rw
field to decide if the can be really merged or not.


Regards,
Muthu


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
