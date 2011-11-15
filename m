From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v2 0/8] Filesystem io types statistic
Date: Tue, 15 Nov 2011 10:34:20 -0800
Message-ID: <CAGr1F2E-pdHqVam27fWXRtWZ0K7=e2GPxOu5HsbhQPrnr=aoLw@mail.gmail.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
 <1321008926.2710.39.camel@menhir> <20111111153246.GA6826@gmail.com>
 <1321266181.2731.8.camel@menhir> <20111114133536.GA4437@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Steven Whitehouse <swhiteho@redhat.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50677 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab1KOSen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 13:34:43 -0500
Received: by yenq3 with SMTP id q3so945758yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 10:34:42 -0800 (PST)
In-Reply-To: <20111114133536.GA4437@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 14, 2011 at 5:35 AM, Zheng Liu <gnehzuil.liu@gmail.com> wro=
te:
> On Mon, Nov 14, 2011 at 10:23:01AM +0000, Steven Whitehouse wrote:
>> Hi,
>>
>> On Fri, 2011-11-11 at 23:32 +0800, Zheng Liu wrote:
>> > On Fri, Nov 11, 2011 at 10:55:26AM +0000, Steven Whitehouse wrote:
>> > > Hi,
>> > >
>> > > On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
>> > > > Hi all,
>> > > >
>> > > > v1->v2: totally redesign this mechanism
>> > > >
>> > > > This patchset implements an io types statistic mechanism for f=
ilesystem
>> > > > and it has been added into ext4 to let us know how the ext4 is=
 used by
>> > > > applications. It is useful for us to analyze how to improve th=
e filesystem
>> > > > and applications. Nowadays, I have added it into ext4, but oth=
er filesytems
>> > > > also can use it to count the io types by themselves.
>> > > >
>> > > > A 'Issue' flag is added into buffer_head and will be set in su=
bmit_bh().
>> > > > Thus, we can check this flag in filesystem to know that a requ=
est is issued
>> > > > to the disk when this flag is set. Filesystems just need to ch=
eck it in
>> > > > read operation because filesystem should know whehter a write =
request hits
>> > > > cache or not, at least in ext4. In filesystem, buffer needs to=
 be locked in
>> > > > checking and clearing this flag, but it doesn't cost much over=
head.
>> > > >
>> >
>> > Hi Steve,
>> >
>> > Thank you for your attention.
>> >
>> > > There is already a REQ_META flag available which allows distinct=
ion
>> > > between data and metadata I/O (at least when they are not contai=
ned
>> > > within the same block). If that was to be extended to allow some
>> > > filesystem specific bits that would solve the problem that you a=
ppear to
>> > > be addressing with these patches in a fs independent way.
>> >
>> > You are right. REQ_META flag quite can distinguish between metadat=
a and
>> > data. But it is difficulty to check this flag in filesystem becaus=
e
>> > buffer_head doesn't use it and most of filesystems still use buffe=
r_head
>> > to submit a IO request. This is the reason why I added a new flag =
into
>> > buffer_head.
>> >
>> I don't understand what you mean here.... submit_bh() takes a bh and=
 a
>> set of REQ flags, so there is no reason to not use REQ_META. Using a=
 bh
>> doesn't prevent setting those flags. The issue is only that few bits
>> remain unused in those flags and solving the problem in a "nice" way=
, by
>> adding a few more flags, may be tricky.
>
> Hi,
>
> Please let me explain why a new flag is needed in buffer_head.
>
> The goal of this patchset wants to provide a mechanism to let
> filesystems can inspect how much different types of IOs are issued to
> the disk. The types not only are divided into metadata and data. The
> detailed types are needed, such as super_block, inode, EA and so on.
> So filesystem needs to define some counters to save the result and
> increase these counters when it makes a request. But filesystems coul=
dn't
> know whether or not this request is issued to the disk because the da=
ta
> might be in page cache, at least read operation is like that. So we n=
eed
> a solution to let filesystems know that. Meanwhile filesystems can fr=
ee
> choose whether or not providing the statistic result.
>
> A new flag can be added into buffer_head and is set when the request =
is
> really issued to the disk to let filesystem know that. But it seems t=
hat
> REQ_META flag could not fit for us because REQ flags are used in bio.
> Buffer_head couldn't use these flags. So filesystem cannot check this
> flag that has been set or not. Further, AFAIK, some filesystems (e.g.
> ext4) call sb_bread() and sb_breadahead() to do a read operation besi=
des
> submit_bh() and ll_rw_block(). It seems that there is no way to check
> REQ_META flag from buffer_head too.
>

As part of some other work, I had added ext4's own submit_bh functions
and replaced all the calls to submit_bh() and ll_rw_block() with
these:

------ x ------

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
+void ext4_submit_bh_read_nowait(int rw, struct buffer_head *bh)
+{
+       BUG_ON(rw & WRITE);
+       BUG_ON(!buffer_locked(bh));
+       get_bh(bh);
+       bh->b_end_io =3D end_buffer_read_sync;
+       submit_bh(rw, bh);
+}
+
+int ext4_submit_bh_read(int rw, struct buffer_head *bh)
+{
+       BUG_ON(rw & WRITE);
+       BUG_ON(!buffer_locked(bh));
+
+       if (buffer_uptodate(bh)) {
+               unlock_buffer(bh);
+               return 0;
+       }
+
+       ext4_submit_bh_read_nowait(rw, bh);
+       wait_on_buffer(bh);
+       if (buffer_uptodate(bh))
+               return 0;
+       return -EIO;
+}
+
 struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
                               ext4_lblk_t block, int create, int *err)
 {
@@ -1572,11 +1598,9 @@ struct buffer_head *ext4_bread(handle_t
*handle, struct inode *inode,
        bh =3D ext4_getblk(handle, inode, block, create, err);
        if (!bh)
                return bh;
-       if (buffer_uptodate(bh))
+       if (bh_uptodate_or_lock(bh))
                return bh;
-       ll_rw_block(READ_META, 1, &bh);
-       wait_on_buffer(bh);
-       if (buffer_uptodate(bh))
+       if (!ext4_submit_bh_read(READ_META, bh))
                return bh;
        put_bh(bh);
        *err =3D -EIO;

------ x ------

I had made the change only for reads, but it should be easy to make it
do writes to. Also, this function can take ext4 specific flags and you
can do your accounting at a single place in ext4. So, you wont need
any more flags for buffer head.
Will this approach help in what you are trying to do?

Thanks,

> Hopefully the explaination is clear enough, and any comments or
> suggestions are welcome. Thanks again. :-)
>
> Regards,
> Zheng
>
>>
>> > >
>> > > That would probably have already been done, except that the REQ_=
 flags
>> > > field is already almost full - so it might need the addition of =
an extra
>> > > field or some other solution.
>> >
>> > In v1[1], a structure called ios is defined. This structure saves =
some
>> > information (e.g. IO type) and a callback function. Some interface=
s in
>> > buffer layer are modifed to add a new argument that points to this
>> > structure. When this request doesn't hit cache and is issued to th=
e
>> > disk, the callback function in this structure will be called. File=
system
>> > can define a function to do some operations. A defect in this solu=
tion
>> > is that it needs to change some interfaces, such bread, breadahead=
 and
>> > so on. So in v2, I re-implement a new mechanism.
>> >
>> > >
>> > > Either way, an fs independent solution to this problem would be =
worth
>> > > considering,
>> >
>> > Yes, I am willing to implement an fs independent solution. This is=
 my
>> > original intention too. So any suggestions are welcome. Thank you.
>> >
>> > [1] http://www.spinics.net/lists/linux-ext4/msg28608.html
>> >
>> > Regards,
>> > Zheng
>> >
>> Ok. Sounds good. GFS2 already sets REQ_META in all places where meta=
data
>> is being written. Now that REQ_META as been demerged from the REQ_PR=
IO
>> flag, there is no reason that filesystems cannot set it without fear=
 of
>> side effects. Its only purpose is as a notification to blktrace now,
>>
>> Steve.
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
