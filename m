From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] ext4: add an io-tree to track block allocation
Date: Thu, 21 Jun 2012 19:48:58 +0800
Message-ID: <20120621114858.GA18931@gmail.com>
References: <20120621094648.GA17503@gmail.com>
 <CAGBYx2Z5XWrN70ka+1TSUqQowRzc=2UgBGJvAwvriKngN8xPMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59812 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2FULk6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 07:40:58 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2Z5XWrN70ka+1TSUqQowRzc=2UgBGJvAwvriKngN8xPMg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 21, 2012 at 07:04:31PM +0800, Yongqiang Yang wrote:
> On Thu, Jun 21, 2012 at 5:46 PM, Zheng Liu <gnehzuil.liu@gmail.com> w=
rote:
> > Hi all,
> >
> > This year at ext4 workshop a new idea that calls io-tree is propose=
d to
> > solve some problmes in ext4 [1]. =C2=A0I summarize the problems tha=
t are
> > needed to solve by io-tree in here:
> > 1. reserve quota calculation in bigalloc
> > 2. simplify puch hole implementation
> > 3. simplify fiemap implementation
> > 4. SEEK_DATA/HOLE implementation
> Actually, we can accelerate
>  ext4_da_write_cache_pages by looking up extent status tree rather
> than page cache.  This is one of aims of the original patch sets.

Thanks for the feedback.  I will add it in my TODO list.

>=20
> >
> > Meanwhile with io-tree, some codes can be improved as following:
> > 1. accelerate get_block functions
> > 2. simplify uninitialized extent conversion
> > 3. fine granularity locking (extent lock)
> >
> > I make a plan to implement io-tree that can be divided into three-s=
teps.
> > Now I describe it in detailed.
> >
> > * Step 1
> > The following problems will be solved in this step:
> > 1. reserve quota calculation in bigalloc
> > 2. simplify puch hole implementation
> > 3. simplify fiemap implementation
> > 4. SEEK_DATA/HOLE implementation
> >
> > Currently a patch set has been submitted to the mailing list by
> > Yongqiang and Allison, which called status extent tree, and it has
> > simplified fiemap implementation. =C2=A0But it only works when dela=
y
> In my memory  reserveing quota for bigalloc is also resolved in the
> original patch sets.  Was it sent out?  If not, I can send the patch
> to you if you need it:-)

I think that this patch is 'ext4: reimplement
ext4_find_delay_alloc_range on status extent tree'.  Right?

>=20
> > allocation is enabled. =C2=A0I will pick up this work. =C2=A0Now I =
have rebased
> > this patch set to 3.5-rc3, and renamed it to extent status tree as
> > Darrick advised.
> >
> > Next I will try to solve the above problems and make it run in
> > nodelalloc mode.
> >
> > * Step 2
> > To be improved:
> > 1. accelerate get_block functions
> > 2. simplify uninitialized extent conversion
> IMHO ext4_da_write_cache_pages can be improved in this step.
>=20
> Yongqiang.
> >
> > For the above improvements, a status member will be added in extent
> > status tree to indicate the current status of this extent. =C2=A0I =
think that
> > the status includes dealloc, allocated, uninit, and hole. =C2=A0The=
n we can
> > let get_block functions to lookup extent status tree firstly to
> > accelerate get_block. =C2=A0Meanwhile uninitialized extent conversi=
on can be
> > modified to reduce lock contention of i_mutex.
> >
> > * Step 3
> > To be done:
> > 1. fine granularity locking (extent lock)
> >
> > Now in ext4 it does some operations with i_mutex locking. =C2=A0Aft=
er adding
> > extent status tree, we can avoid to take this lock as much as possi=
ble.
> > It seems that a new member needs to be added to indicate the type o=
f
> > locking. =C2=A0We can take a range lock with shared or exclusive, a=
nd, when a
> > range is locked, it cannot be merged by other processes and other t=
ypes
> > extent lock.
> >
> > Dave Chinner said that maybe range lock can be used in xfs too. =C2=
=A0So I
> > will try to implement a generic extent locking as much as possible =
after
> > step 3.
> >
> > Please review this RFC, and any feedbacks are appreciated. =C2=A0Th=
anks.
> >
> > In addition, I remember that at ext4 workshop Ted mentions that a b=
ig
> > extent tree has been implemented to improve extent cache. =C2=A0So =
we need to
> > consider whether need to merge big extent tree and io-tree or not a=
fter
> > both big extent tree and io-tree have been done.
> >
> > 1. http://www.spinics.net/lists/linux-ext4/msg31742.html
> >
> > Regards,
> > Zheng
>=20
>=20
>=20
> --=20
> Best Wishes
> Yongqiang Yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
