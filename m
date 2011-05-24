From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests:Make 225 compare map and fiemap at each
 block.
Date: Tue, 24 May 2011 15:18:27 +1000
Message-ID: <20110524051827.GF32466@dastard>
References: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
 <20110524015105.GE32466@dastard>
 <BANLkTikWgG2E1EYcm+B2zxBCY=KH-Rb0Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, josef@redhat.com, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57242 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab1EXFSn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 01:18:43 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikWgG2E1EYcm+B2zxBCY=KH-Rb0Dw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2011 at 10:42:23AM +0800, Yongqiang Yang wrote:
> Thank you for your review.
> On Tue, May 24, 2011 at 9:51 AM, Dave Chinner <david@fromorbit.com> w=
rote:
> > On Mon, May 23, 2011 at 03:07:03PM +0800, Yongqiang Yang wrote:
> >> Due to my carelessness, =A0I induced a ugly patch to ext4's fiemap=
, as a result
> >> delayed-extents that did not start at the head block of a page was=
 ignored
> >> in ext4 with 1K block, but 225 could not find it.
> >
> > When ext4 is using 1k block sizes, fiemap-tester does not find
> > problems that may exist on ext4 with delayed allocation extents on
> > the first block of a page.
> >
> >> So I looked into the 225
> >> and could not figure out logic in compare_map_and_fiemap(), which =
seemed to
> >> mix extents with blocks.
> >
> > Once again, "I don't understand it" is not a reason for a whoelsale
> > rewrite.
> >
> >> Then I made 225 compare map and fiemap at each block,
> >> the new 225 can find the bug I induced and another bug in ext4 wit=
h 1k block,
> >> which ignored delayed-extents after a hole, which did not start at=
 the head
> >> block of a page.
> >
> > Which means that the first paragraph should read:
> >
> > "When ext4 is using 1k block sizes, fiemap-tester does not find
> > problems that may exist on ext4 with delayed allocation extents on
> > the first block of a page or directly after a hole."
> >
> > That's a concise description of the overall problem you are fixing
> > in this patch. Next you need to describe the different changes bein=
g
> > made in the patch and the bugs they are fixing. =A0There appear to =
be:
> >
> > =A0 =A0 =A0 =A0- an off-by one in map array allocation
> > =A0 =A0 =A0 =A0- zeroing the end block in the map array
> > =A0 =A0 =A0 =A0- making check_weird_fs_hole() verify bytes read by =
pread()
> > =A0 =A0 =A0 =A0- moving truncate/seek of the test file around
> > =A0 =A0 =A0 =A0- changing the way map/fiemap are compared
> Yes, thank you.

I'm not asking you to ACK the list of changes in the bug - I'm
asking you to describe the symptoms of the problems those fixes
apparently address - how you've found them , what the test failures
looked like, etc, so there's some meaningful record of why those
changes were made.

> > Also, you haven't addressed any of the comments I made in my
> > original review:
> >
> > =A0 =A0 =A0 =A0- removing the changelog from the header comment
> The change is large, so I think  it's convenient for others to leave
> an e-mail in the file in case that they have some questions.

That's what git log/git blame is for. Details of who made what
change has no place in the code itself - recording that information
ina queriable format is precisely the reason we use a VCS.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
