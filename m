From: Jan Kara <jack@suse.cz>
Subject: Re: recursive mtime patches
Date: Thu, 14 Apr 2011 11:21:17 +0200
Message-ID: <20110414092117.GB5054@quack.suse.cz>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
 <20110412154830.GF5246@quack.suse.cz>
 <BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
 <20110413213937.GB4648@quack.suse.cz>
 <BANLkTi=NDb0U0z1C4UEE2oHvE8fVBVDp=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab1DNJVT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 05:21:19 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=NDb0U0z1C4UEE2oHvE8fVBVDp=Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-04-11 10:12:26, Amir Goldstein wrote:
> On Thu, Apr 14, 2011 at 12:39 AM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 13-04-11 21:16:40, Amir Goldstein wrote:
> >> On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote:
> >> > modification stamps have possibly larger race windows but I have=
n't really
> >> > tried how much (I just know that even mtime races are not that h=
ard to
> >> > trigger if you try). So it really depends on how big reliability=
 do you
> >> > expect and I personally don't find much value in just rescanning=
 and
> >> > checking for mtime after a crash. Reading all the data and doing=
 checksum
> >> > certainly has more value but at a high cost.
> >> >
> >>
> >> What do you thing about the approach to store recursively modified=
 dir inodes in
> >> a journal "modified inode descriptor block" and update the recursi=
ve mtime of
> >> those dirs on journal recovery?
> > =A0The trouble is you don't know the number of directories that may=
 need
> > to have timestamp updated - you find that out only as you travel up=
wards.
> > So it's hard to reserve any fixed space for this.
> >
>=20
> True, but you can save *so* many inode numbers in just one descriptor
> block and in case of an overflow, we can just pass a hint to the top
> level application to do a full directory scan, so I hardly see that a=
s a
> big problem.
  Well, about 1000 but you can still have about 8000 inodes modified in=
 a
transaction for a standard 128 MB journal. You can notify the userspace
when an overflow happens but the interface gets kind of ugly... Also it
would be only specific to ext3/4 while I'd prefer to get a wider fs
support.

> >> I would also consider to use a mount option rec_mtime and then jus=
t
> >> store recursive
> >> mtime in the directory's inode mtime instead of an extended attrib=
ute.
> >> That doesn't break any contract with user space, it's just a re-in=
terpretation
> >> of the dir modification notion.
> > =A0It breaks POSIX specification - POSIX pretty much specifies when=
 mtime is
> > supposed to be changed - so I'm not sure we really want to do that.=
=2E.
>=20
> I disagree, POSIX doesn't forbid a user space daemon from touching di=
rectory
> inodes and updating their mtime. The rec_mtime feature should be trea=
ted as
> a little kernel "daemon" which propagates information to user space b=
y touching
> recursively modified directories.
  OK, if you look at it this way it makes some sense. You loose the
distinction whether something has been created / deleted in the directo=
ry
or whether only something happened in its subdirectory or file but that
does not seem too important for any use case I can think of.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
