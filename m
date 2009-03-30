From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 17:26:12 +0200
Message-ID: <200903301726.12548.bzolnier@gmail.com>
References: <200903291928.14451.bzolnier@gmail.com> <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= <flvazquez@uvigo.es>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:50553 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZC3PWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 11:22:47 -0400
In-Reply-To: <49D0C29C.1060307@uvigo.es>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

On Monday 30 March 2009, Fernando Luis V=E1zquez Cao wrote:
> Chris Mason wrote:
> > On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
> >> Theodore Tso wrote:
> >>> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
> >>>> As long as we keep the call there this is probably good, but aft=
er
> >>>> talking w/ Chris Mason, I think the call is extraneous anyway an=
d should
> >>>> probably just be removed...
> >>>>
> >>> Yes, I agree, but it takes a lot of digging to be completely sure=
 of
> >>> that it's safe to remove it.  Interestingly, it was you who added=
 the
> >>> patch which added the call to blkdev_issue_flush():
> >>> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
> >>> Author: Eric Sandeen <sandeen@redhat.com>
> >>> Date:   Fri Jul 11 19:27:31 2008 -0400
> >>
> >> Yes, it was.  Although I got the idea when hch pointed out that Su=
SE did
> >> this... thanks to Chris.  It's come full circle.  :)
> >=20
> > Grin.  I'm not sure the I_DIRTY checks alone are enough to decide t=
hat a
> > commit is required though.  I think the inode could be clean but st=
ill
> > have metadata that needs commit.
>=20
> Chris, I have just sent patches that attempt to fix both ext3 and
> ext4 while also adding a per-device sysfs knob tu disable
> write-flushes. A previous version of this patch set added a new
> generic mount option but comments from Christoph and others
> convinced me to turn it into a per-device tunable. Could you take
> a look at the patches?
>=20
> Bartlomiej, I have just noticed that I happened to be working on
> patches for reiserfs and xfs similar to the ones you sent earlier
> this week. I picked some bits from your submission so I took the
> liberty to add your signed-off to my patches. Could you take a
> look at them and let me know if you are confortable with that?

I'm fine with people building bigger changes on top of my patches
but if you do so you please clearly denote in the patch description
what changes you have applied to the original patch...

Thanks,
Bart
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
