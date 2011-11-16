From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 0/8] Filesystem io types statistic
Date: Wed, 16 Nov 2011 16:43:11 +0800
Message-ID: <20111116084311.GA21356@gmail.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
 <1321008926.2710.39.camel@menhir>
 <20111111153246.GA6826@gmail.com>
 <1321266181.2731.8.camel@menhir>
 <20111114133536.GA4437@gmail.com>
 <CAGr1F2E-pdHqVam27fWXRtWZ0K7=e2GPxOu5HsbhQPrnr=aoLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steven Whitehouse <swhiteho@redhat.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65306 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1KPIli (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 03:41:38 -0500
Content-Disposition: inline
In-Reply-To: <CAGr1F2E-pdHqVam27fWXRtWZ0K7=e2GPxOu5HsbhQPrnr=aoLw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 10:34:20AM -0800, Aditya Kali wrote:
> On Mon, Nov 14, 2011 at 5:35 AM, Zheng Liu <gnehzuil.liu@gmail.com> w=
rote:
> > On Mon, Nov 14, 2011 at 10:23:01AM +0000, Steven Whitehouse wrote:
> >> Hi,
> >>
> >> On Fri, 2011-11-11 at 23:32 +0800, Zheng Liu wrote:
> >> > On Fri, Nov 11, 2011 at 10:55:26AM +0000, Steven Whitehouse wrot=
e:
> >> > > Hi,
> >> > >
> >> > > On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
> >> > > > Hi all,
> >> > > >
> >> > > > v1->v2: totally redesign this mechanism
> >> > > >
> >> > > > This patchset implements an io types statistic mechanism for=
 filesystem
> >> > > > and it has been added into ext4 to let us know how the ext4 =
is used by
> >> > > > applications. It is useful for us to analyze how to improve =
the filesystem
> >> > > > and applications. Nowadays, I have added it into ext4, but o=
ther filesytems
> >> > > > also can use it to count the io types by themselves.
> >> > > >
> >> > > > A 'Issue' flag is added into buffer_head and will be set in =
submit_bh().
> >> > > > Thus, we can check this flag in filesystem to know that a re=
quest is issued
> >> > > > to the disk when this flag is set. Filesystems just need to =
check it in
> >> > > > read operation because filesystem should know whehter a writ=
e request hits
> >> > > > cache or not, at least in ext4. In filesystem, buffer needs =
to be locked in
> >> > > > checking and clearing this flag, but it doesn't cost much ov=
erhead.
> >> > > >
> >> >
> >> > Hi Steve,
> >> >
> >> > Thank you for your attention.
> >> >
> >> > > There is already a REQ_META flag available which allows distin=
ction
> >> > > between data and metadata I/O (at least when they are not cont=
ained
> >> > > within the same block). If that was to be extended to allow so=
me
> >> > > filesystem specific bits that would solve the problem that you=
 appear to
> >> > > be addressing with these patches in a fs independent way.
> >> >
> >> > You are right. REQ_META flag quite can distinguish between metad=
ata and
> >> > data. But it is difficulty to check this flag in filesystem beca=
use
> >> > buffer_head doesn't use it and most of filesystems still use buf=
fer_head
> >> > to submit a IO request. This is the reason why I added a new fla=
g into
> >> > buffer_head.
> >> >
> >> I don't understand what you mean here.... submit_bh() takes a bh a=
nd a
> >> set of REQ flags, so there is no reason to not use REQ_META. Using=
 a bh
> >> doesn't prevent setting those flags. The issue is only that few bi=
ts
> >> remain unused in those flags and solving the problem in a "nice" w=
ay, by
> >> adding a few more flags, may be tricky.
> >
> > Hi,
> >
> > Please let me explain why a new flag is needed in buffer_head.
> >
> > The goal of this patchset wants to provide a mechanism to let
> > filesystems can inspect how much different types of IOs are issued =
to
> > the disk. The types not only are divided into metadata and data. Th=
e
> > detailed types are needed, such as super_block, inode, EA and so on=
=2E
> > So filesystem needs to define some counters to save the result and
> > increase these counters when it makes a request. But filesystems co=
uldn't
> > know whether or not this request is issued to the disk because the =
data
> > might be in page cache, at least read operation is like that. So we=
 need
> > a solution to let filesystems know that. Meanwhile filesystems can =
free
> > choose whether or not providing the statistic result.
> >
> > A new flag can be added into buffer_head and is set when the reques=
t is
> > really issued to the disk to let filesystem know that. But it seems=
 that
> > REQ_META flag could not fit for us because REQ flags are used in bi=
o.
> > Buffer_head couldn't use these flags. So filesystem cannot check th=
is
> > flag that has been set or not. Further, AFAIK, some filesystems (e.=
g.
> > ext4) call sb_bread() and sb_breadahead() to do a read operation be=
sides
> > submit_bh() and ll_rw_block(). It seems that there is no way to che=
ck
> > REQ_META flag from buffer_head too.
> >
>=20
> As part of some other work, I had added ext4's own submit_bh function=
s
> and replaced all the calls to submit_bh() and ll_rw_block() with
> these:
>=20
> ------ x ------
>=20
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> +void ext4_submit_bh_read_nowait(int rw, struct buffer_head *bh)
> +{
> +       BUG_ON(rw & WRITE);
> +       BUG_ON(!buffer_locked(bh));
> +       get_bh(bh);
> +       bh->b_end_io =3D end_buffer_read_sync;
> +       submit_bh(rw, bh);
> +}
> +
> +int ext4_submit_bh_read(int rw, struct buffer_head *bh)
> +{
> +       BUG_ON(rw & WRITE);
> +       BUG_ON(!buffer_locked(bh));
> +
> +       if (buffer_uptodate(bh)) {
> +               unlock_buffer(bh);
> +               return 0;
> +       }
> +
> +       ext4_submit_bh_read_nowait(rw, bh);
> +       wait_on_buffer(bh);
> +       if (buffer_uptodate(bh))
> +               return 0;
> +       return -EIO;
> +}
> +
>  struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode=
,
>                                ext4_lblk_t block, int create, int *er=
r)
>  {
> @@ -1572,11 +1598,9 @@ struct buffer_head *ext4_bread(handle_t
> *handle, struct inode *inode,
>         bh =3D ext4_getblk(handle, inode, block, create, err);
>         if (!bh)
>                 return bh;
> -       if (buffer_uptodate(bh))
> +       if (bh_uptodate_or_lock(bh))
>                 return bh;
> -       ll_rw_block(READ_META, 1, &bh);
> -       wait_on_buffer(bh);
> -       if (buffer_uptodate(bh))
> +       if (!ext4_submit_bh_read(READ_META, bh))
>                 return bh;
>         put_bh(bh);
>         *err =3D -EIO;
>=20
> ------ x ------
>=20
> I had made the change only for reads, but it should be easy to make i=
t
> do writes to. Also, this function can take ext4 specific flags and yo=
u
> can do your accounting at a single place in ext4. So, you wont need
> any more flags for buffer head.
> Will this approach help in what you are trying to do?
>=20
> Thanks,

Hi Aditya,

Thank you for your patch. It quite can help me to solve my problem. We
can define some wrapper functions to do our accounting in ext4. But it
seems that this approach is just suitable for ext4. I prefer to
provide a fs independent solution. Steven and I are talking about how t=
o
implement it to let other filesystems can use this mechanism directly t=
o
do their accouting. If you have some suggestions, feel free to tell me.

Regards,
Zheng

>=20
> > Hopefully the explaination is clear enough, and any comments or
> > suggestions are welcome. Thanks again. :-)
> >
> > Regards,
> > Zheng
> >
> >>
> >> > >
> >> > > That would probably have already been done, except that the RE=
Q_ flags
> >> > > field is already almost full - so it might need the addition o=
f an extra
> >> > > field or some other solution.
> >> >
> >> > In v1[1], a structure called ios is defined. This structure save=
s some
> >> > information (e.g. IO type) and a callback function. Some interfa=
ces in
> >> > buffer layer are modifed to add a new argument that points to th=
is
> >> > structure. When this request doesn't hit cache and is issued to =
the
> >> > disk, the callback function in this structure will be called. Fi=
lesystem
> >> > can define a function to do some operations. A defect in this so=
lution
> >> > is that it needs to change some interfaces, such bread, breadahe=
ad and
> >> > so on. So in v2, I re-implement a new mechanism.
> >> >
> >> > >
> >> > > Either way, an fs independent solution to this problem would b=
e worth
> >> > > considering,
> >> >
> >> > Yes, I am willing to implement an fs independent solution. This =
is my
> >> > original intention too. So any suggestions are welcome. Thank yo=
u.
> >> >
> >> > [1] http://www.spinics.net/lists/linux-ext4/msg28608.html
> >> >
> >> > Regards,
> >> > Zheng
> >> >
> >> Ok. Sounds good. GFS2 already sets REQ_META in all places where me=
tadata
> >> is being written. Now that REQ_META as been demerged from the REQ_=
PRIO
> >> flag, there is no reason that filesystems cannot set it without fe=
ar of
> >> side effects. Its only purpose is as a notification to blktrace no=
w,
> >>
> >> Steve.
> >>
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsd=
evel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20
> --=20
> Aditya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
