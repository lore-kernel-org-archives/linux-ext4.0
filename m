From: Jan Kara <jack@suse.cz>
Subject: Re: recursive mtime patches
Date: Thu, 14 Apr 2011 11:49:30 +0200
Message-ID: <20110414094930.GF5054@quack.suse.cz>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
 <20110412154830.GF5246@quack.suse.cz>
 <BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
 <20110413213937.GB4648@quack.suse.cz>
 <BANLkTi=NDb0U0z1C4UEE2oHvE8fVBVDp=Q@mail.gmail.com>
 <20110414092117.GB5054@quack.suse.cz>
 <BANLkTi==jFeJritNiwaA+vYgi6paqyQ_6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab1DNJtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 05:49:31 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi==jFeJritNiwaA+vYgi6paqyQ_6g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-04-11 12:36:40, Amir Goldstein wrote:
> On Thu, Apr 14, 2011 at 12:21 PM, Jan Kara <jack@suse.cz> wrote:
> > On Thu 14-04-11 10:12:26, Amir Goldstein wrote:
> >> On Thu, Apr 14, 2011 at 12:39 AM, Jan Kara <jack@suse.cz> wrote:
> >> > On Wed 13-04-11 21:16:40, Amir Goldstein wrote:
> >> >> On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote:
> >> >> > modification stamps have possibly larger race windows but I h=
aven't really
> >> >> > tried how much (I just know that even mtime races are not tha=
t hard to
> >> >> > trigger if you try). So it really depends on how big reliabil=
ity do you
> >> >> > expect and I personally don't find much value in just rescann=
ing and
> >> >> > checking for mtime after a crash. Reading all the data and do=
ing checksum
> >> >> > certainly has more value but at a high cost.
> >> >> >
> >> >>
> >> >> What do you thing about the approach to store recursively modif=
ied dir inodes in
> >> >> a journal "modified inode descriptor block" and update the recu=
rsive mtime of
> >> >> those dirs on journal recovery?
> >> > =A0The trouble is you don't know the number of directories that =
may need
> >> > to have timestamp updated - you find that out only as you travel=
 upwards.
> >> > So it's hard to reserve any fixed space for this.
> >> >
> >>
> >> True, but you can save *so* many inode numbers in just one descrip=
tor
> >> block and in case of an overflow, we can just pass a hint to the t=
op
> >> level application to do a full directory scan, so I hardly see tha=
t as a
> >> big problem.
> > =A0Well, about 1000 but you can still have about 8000 inodes modifi=
ed in a
> > transaction for a standard 128 MB journal. You can notify the users=
pace
> > when an overflow happens but the interface gets kind of ugly... Als=
o it
> > would be only specific to ext3/4 while I'd prefer to get a wider fs
> > support.
>=20
> Well, the persistent inode notification (by the way a feature provide=
d by NTFS),
> can be specific to ext4, but it can work together with a generic recu=
rsive mtime
> code.
> ext4 will simply touch directories during journal recovery.
> other fs will only have the generic runtime recursive mtime.
  But then applications cannot rely on the behavior and cannot take muc=
h
benefit from it. Well, they could still ignore the risks and ext4 would=
 be
nicer to them. But I'm not really sure what are you aiming at...

> >> >> I would also consider to use a mount option rec_mtime and then =
just
> >> >> store recursive
> >> >> mtime in the directory's inode mtime instead of an extended att=
ribute.
> >> >> That doesn't break any contract with user space, it's just a re=
-interpretation
> >> >> of the dir modification notion.
> >> > =A0It breaks POSIX specification - POSIX pretty much specifies w=
hen mtime is
> >> > supposed to be changed - so I'm not sure we really want to do th=
at...
> >>
> >> I disagree, POSIX doesn't forbid a user space daemon from touching=
 directory
> >> inodes and updating their mtime. The rec_mtime feature should be t=
reated as
> >> a little kernel "daemon" which propagates information to user spac=
e by touching
> >> recursively modified directories.
> > =A0OK, if you look at it this way it makes some sense. You loose th=
e
> > distinction whether something has been created / deleted in the dir=
ectory
> > or whether only something happened in its subdirectory or file but =
that
> > does not seem too important for any use case I can think of.
>=20
> Personally, whenever I look at a dir mtime I would much rather I see
> recursive mtime (I would much rather see recursive size as well but t=
hat
> is too much to ask).  rsync can be easily modified to skipped entire
> directories if their (recursive) mtime hasn't changed.  I would like =
to
> view dir (recursive) mtime using existing tools (from ls to folder
> manager) and not use specialized tools that look at extended attribut=
es,
> but hey, that's just me :-)
  That would be neat but note that even my patches don't provide comple=
te
recursive mtime behavior. They just update the time stamp once and then
stop updating it until you ask about the update again. This makes the w=
hole
framework really efficient for often modified directories but less usef=
ul
for cases like "I want to see time when something has changed in this
subtree".

But still I kind of like your idea of hijacking directory mtime/ctime f=
or
these purposes because it would make several things simpler.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
