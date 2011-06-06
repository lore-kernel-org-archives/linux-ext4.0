From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 6 Jun 2011 18:05:24 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106061755260.3934@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com> <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com> <4DECF2D5.7050408@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1FFQFi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 12:05:38 -0400
In-Reply-To: <4DECF2D5.7050408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 6 Jun 2011, Eric Sandeen wrote:

> On 6/6/11 9:32 AM, Amir G. wrote:
> > On Mon, Jun 6, 2011 at 4:08 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> >> On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:
> >>>
> >>> MERGING
> >>> -------
> >>> These patches are based on Ted's current master branch + alloc_semp removal
> >>> patches. Although the alloc_semp removal is an independent (and in my eyes
> >>> a good) change, it is also required by snapshot patches, to avoid circular
> >>> locking dependency during COW allocations.
> >>>
> >>> Merging with Allison's punch holes patches should be straight forward, since
> >>> the hard part, namely Yongqiang's split extent refactoring patches, was
> >>> already merged by Ted.
> >>>
> >>> Merging with Ted's big alloc patches is going to be a bit more challenging,
> >>> since big alloc patches make a lot of renaming and refactoring. However,
> >>> since has_snapshots and big_alloc features will never work together,
> >>> at least testing the code together is not a big concern.
> >>
> >> Hi Amir,
> >>
> >> what is the reason for the snapshots to never work with big_alloc ? Just
> >> out of curiosity.
> >>
> > 
> > For one reason, a snapshot file format is currently an indirect file
> > and big_alloc
> > doesn't support indirect mapped files.
> > I am not saying it cannot be done, but if it does, there would be
> > several obstacles
> > to cross.
> 
> I know I'm kind of just throwing a bomb out here, but I am very concerned
> about the ever-growing feature (in)compatibility matrix in ext4.
> 
> Take for example dioread_nolock caveats:
> 
>           "However this does not work with nobh
>            option and the mount will fail. Nor does it work with
>            data journaling and dioread_nolock option will be
>            ignored with kernel warning. Note that dioread_nolock
>            code path is only used for extent-based files."
> 
> If ext4 matches the lifespan of ext3, in 10 years I fear that it will look
> more like a collection of various individuals' pet projects, rather than
> any kind of well-designed, cohesive project.
> 
> How long can we really keep adding features which are semi- or wholly-
> incompatible with other features?
> 
> Consider this a cry in the wilderness for less rushed feature introduction,
> and a more holistic approach to ext4 design...

Well, we can also start ditching some unused features and tunnables, or
make it default and remove it from documentation so people will not use
it and we can get rid of some of the options in the future. For examle 

orlov
oldalloc
bsddf
minixdf

seems like a good start from the first glance...

Thanks!
-Lukas

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
