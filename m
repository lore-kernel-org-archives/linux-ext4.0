From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 09:24:19 -0400
Message-ID: <1238419459.30488.42.camel@think.oraclecorp.com>
References: <200903291928.14451.bzolnier@gmail.com>
	 <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>
	 <49D03AE1.8070009@redhat.com>
	 <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao <flvazquez@uvigo.es>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752427AbZC3NZk@vger.kernel.org>
In-Reply-To: <49D0C29C.1060307@uvigo.es>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2009-03-30 at 22:01 +0900, Fernando Luis V=C3=A1zquez Cao wrote=
:
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

Jens' comment are right on I think.  If we get that fixed up we can get
rid of all the filesystem mount -o barrier=3Dflush,0,1,xyz confusion an=
d
set it via the block devices directly.

That would be nice ;)

-chris
