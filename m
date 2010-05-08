From: tytso@mit.edu
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 8 May 2010 13:25:57 -0400
Message-ID: <20100508172557.GK18762@thunk.org>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
 <20100504224226.GE6344@thunk.org>
 <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>
 <87vdaz21b0.fsf@basil.nowhere.org>
 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
 <4BE4855E.40808@redhat.com>
 <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
 <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
 <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44985 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0EHR0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 May 2010 13:26:12 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 08, 2010 at 06:07:40PM +0200, Amir G. wrote:
> 
> Next3 is another implementation of the extended f/s format.
> Next3 is a superset of ext3 plus snapshots.

As long as Next3 uses fields which have already assigned to ext4, this
is a claim that you can not make correctly.  Because, you see, the
ext4 is also an implementation of the extended f/s format, and those
field assignments have already been made.

> All overlapping field issues can be resolved.

As long as you are willing to say that, then sure, let's work towards
that goal.


> It makes me very happy that you've studied Next3 enough to be able to
> make this almost correct observation.
> I do plan to use indirect mapped snapshot files when I merge them to Ext4.
> The only place that extent mapped files break the snapshots design is
> when doing move-on-write
> when writing in-place to extent mapped file.
> Should the extent be broken into 2 extents + single block and then
> move the block to snapshot?
> Should the block be copied-on-write instead of moved-on-write and pay
> the performance penalty?

If you do the "move-on-write" trick, you just have to split the extent
and do a COW of the extent tree and/or the inode.  So for a single
block, the performance hit the same, yes?  But in the long-run, it's
probably more efficient to do "move-on-write".

> There is an important design decision to make here.

Technically speaking, it's possible to do it both way, yes?  I'm not
sure why you consider this such a important design decision.  We can
even play games where for some files we might do copy-on-write, and
for some files, we do move-on-write.  It's always possible to check
the COW bitmaps to decide what had happened.

In any case, if this is all you have to do, I'm not sure why you said
it was fundamentally impossible to support extents with the Next3
design.

Best regards,

						- Ted
