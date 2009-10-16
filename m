From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Fri, 16 Oct 2009 12:44:24 -0700
Message-ID: <5df78e1d0910161244s3f47fe02s1ede2093b8aeacbf@mail.gmail.com>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910142214s51a4db0and358fc432225338b@mail.gmail.com>
	 <1255627868.4377.1113.camel@mingming-laptop>
	 <5df78e1d0910151307p342a0c71x5413fad2202a1daa@mail.gmail.com>
	 <1255649304.4377.1155.camel@mingming-laptop>
	 <5df78e1d0910151633s54ef6bb5pe1957eb0cf33eff6@mail.gmail.com>
	 <1255719403.4377.1168.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:53459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZJPToY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 15:44:24 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id n9GJiRYw007013
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 20:44:27 +0100
Received: from ywh8 (ywh8.prod.google.com [10.192.8.8])
	by wpaz17.hot.corp.google.com with ESMTP id n9GJiOeT002482
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 12:44:24 -0700
Received: by ywh8 with SMTP id 8so2237373ywh.3
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 12:44:24 -0700 (PDT)
In-Reply-To: <1255719403.4377.1168.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 16, 2009 at 11:56 AM, Mingming <cmm@us.ibm.com> wrote:
> On Thu, 2009-10-15 at 16:33 -0700, Jiaying Zhang wrote:
>> On Thu, Oct 15, 2009 at 4:28 PM, Mingming <cmm@us.ibm.com> wrote:
>> > On Thu, 2009-10-15 at 13:07 -0700, Jiaying Zhang wrote:
>> >> On Thu, Oct 15, 2009 at 10:31 AM, Mingming <cmm@us.ibm.com> wrote=
:
>> >> > On Wed, 2009-10-14 at 22:14 -0700, Jiaying Zhang wrote:
>> >> >> Mingming,
>> >> >>
>> >> >
>> >> > Hi Jiaying,
>> >> >
>> >> >> On Wed, Oct 14, 2009 at 11:48 AM, Mingming <cmm@us.ibm.com> wr=
ote:
>> >> >> > On Fri, 2009-10-09 at 16:34 -0700, Jiaying Zhang wrote:
>> >> >> >> Hello,
>> >> >> >>
>> >> >> >> Recently, we are evaluating the ext4 performance on a high =
speed SSD.
>> >> >> >> One problem we found is that ext4 performance doesn't scale=
 well with
>> >> >> >> multiple threads or multiple AIOs reading a single file wit=
h O_DIRECT.
>> >> >> >> E.g., with 4k block size, multiple-thread DIO AIO random re=
ad on ext4
>> >> >> >> can lose up to 50% throughput compared to the results we ge=
t via RAW IO.
>> >> >> >>
>> >> >> >> After some initial analysis, we think the ext4 performance =
problem is caused
>> >> >> >> by the use of i_mutex lock during DIO read. I.e., during DI=
O read, we grab
>> >> >> >> the i_mutex lock in __blockdev_direct_IO because ext4 uses =
the default
>> >> >> >> DIO_LOCKING from the generic fs code. I did a quick test by=
 calling
>> >> >> >> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I s=
aw ext4 DIO read
>> >> >> >> got 99% performance as raw IO.
>> >> >> >>
>> >> >> >
>> >> >> > This is very interesting...and impressive number.
>> >> >> >
>> >> >> > I tried to change ext4 to call blockdev_direct_IO_no_locking=
() directly,
>> >> >> > but then realize that we can't do this all the time, as ext4=
 support
>> >> >> > ext3 non-extent based files, and uninitialized extent is not=
 support on
>> >> >> > ext3 format file.
>> >> >> >
>> >> >> >> As we understand, the reason why we want to take i_mutex lo=
ck during DIO
>> >> >> >> read is to prevent it from accessing stale data that may be=
 exposed by a
>> >> >> >> simultaneous write. We saw that Mingming Cao has implemente=
d a patch set
>> >> >> >> with which when a get_block request comes from direct write=
, ext4 only
>> >> >> >> allocates or splits an uninitialized extent. That uninitial=
ized extent
>> >> >> >> will be marked as initialized at the end_io callback.
>> >> >> >
>> >> >> > Though I need to clarify that with all the patches in mainli=
ne, we only
>> >> >> > treat new allocated blocks form direct io write to holes, no=
t to writes
>> >> >> > to the end of file. I actually have proposed to treat the wr=
ite to the
>> >> >> > end of file also as unintialized extents, but there is some =
concerns
>> >> >> > that this getting tricky with updating inode size when it is=
 async IO
>> >> >> > direct IO. So it didn't getting done yet.
>> >> >>
>> >> >> I read you previous email thread again. As I understand, the m=
ain
>> >> >> concern for allocating uninitialized blocks in i_size extendin=
g write
>> >> >> is that we may end up having uninitialized blocks beyond i_siz=
e
>> >> >> if the system crashes during write. Can we protect this case b=
y
>> >> >> adding the inode into the orphan list in ext4_ext_direct_IO,
>> >> >> i.e., same as we have done in ext4_ind_direct_IO?
>> >> >>
>> >> >
>> >> > Sure we could do that, though initially I hoped we could get ri=
d of
>> >> > that:)
>> >> >
>> >> > The tricky part is async direct write to the end of file. By th=
e time
>> >> > the IO is completed, the inode may be truncated or extended lar=
ger.
>> >> > Updating the most "safe" size is the part I haven't thought thr=
ough yet.
>> >> >
>> >>
>> >> Ok. I think I understand the problem better now :).
>> >>
>> >> Looking at the __blockdev_direct_IO(), I saw it actually treats
>> >> size-extending aio dio write as synchronous and expects the dio t=
o
>> >> complete before return (fs/direct-io.c line 1204 and line 1056-10=
61).
>> >
>> > Oh? It seems it will keep the write async as long as it's not a pa=
rtial
>> > write
>> > =A0 =A0 =A0 =A0/*
>> > =A0 =A0 =A0 =A0 * The only time we want to leave bios in flight is=
 when a successful
>> > =A0 =A0 =A0 =A0 * partial aio read or full aio write have been set=
up. =A0In that case
>> > =A0 =A0 =A0 =A0 * bio completion will call aio_complete. =A0The on=
ly time it's safe to
>> > =A0 =A0 =A0 =A0 * call aio_complete is when we return -EIOCBQUEUED=
, so we key on that.
>> > =A0 =A0 =A0 =A0 * This had *better* be the only place that raises =
-EIOCBQUEUED.
>> > =A0 =A0 =A0 =A0 */
>> > =A0 =A0 =A0 =A0BUG_ON(ret =3D=3D -EIOCBQUEUED);
>> > =A0 =A0 =A0 =A0if (dio->is_async && ret =3D=3D 0 && dio->result &&
>> > =A0 =A0 =A0 =A0 =A0 =A0((rw & READ) || (dio->result =3D=3D dio->si=
ze)))
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EIOCBQUEUED;
>> >
>> > =A0 =A0 =A0 =A0if (ret !=3D -EIOCBQUEUED)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dio_await_completion(dio);
>> >
>>
>> If I read the code correctly, dio->is_async is not set for file exte=
nding write:
>>
>> =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0* For file extending writes updating i_size befor=
e data
>> =A0 =A0 =A0 =A0 =A0* writeouts complete can expose uninitialized blo=
cks. So
>> =A0 =A0 =A0 =A0 =A0* even for AIO, we need to wait for i/o to comple=
te before
>> =A0 =A0 =A0 =A0 =A0* returning in this case.
>> =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 dio->is_async =3D !is_sync_kiocb(iocb) && !((rw & WR=
ITE) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (end > i_size_read(inode)));
>>
>
> Ah... that's a little surprise to know. Async write to the end of fil=
e
> is actually synchonous. That explains why ext3 async direct IO could
> always expand inode i_size safely without having to worry about expos=
e
> stale data out.
>
> It would be better to fix this with end_io callback, user expects get
> higher performance via async mode.
>
> But, these are seperate from removing i_mutex lock from direct IO rea=
d,
> IMHO. The dio write to end of file won't extend inode size until the =
IO
> is completed (AIO or non AIO mode). So if we remove the i_mutex lock
> from the dio read, =A0in the case of parallel dio/buffered write to e=
nd of
> file and direct io read, it won't expose updated inode's block mappin=
g
> tree to parallel direct IO read, as the i_size hasn't been changed ye=
t.
>
> The only concern to remove the the lock from dio read path, is the
> buffered write to the hole. Isn't it?
>

Hmm. Will we be safe between dio read and size-extending buffer
write if we don't hold i_mutex lock during dio read but still allocatin=
g
initialized blocks in size-extending buffer write? As I understand, we
update file size in ext4_write_end. The buffer write have finished at
this time but the changes are still in memory. Currently, we prevent
dio read from reading stale data by calling filemap_write_and_wait_rang=
e()
after holding the i_mutex lock in __blockdev_direct_IO(). If we no
longer hold i_mutex during dio read, a buffer write can finish after
a dio read calls filemap_write_and_wait_range() but before it calls
get_block(). At the time that dio read calls get_block(), the i_size
of the file has been updated, but the written data is still in memory,
so it may read stale data.

I was thinking that we may change to call filemap_write_and_wait_range(=
)
after get_block() during dio read. This seems to eliminate the above
problem. However, I am also worried about non-journal ext4. With the
current code, I think there is a chance that we can expose stale data
after reboot if the system crashed at a bad time. I think always
converting uninitialized blocks to initialized during end_io time may
help to close this security hole in non-journal ext4.

Jiaying

>> Jiaying
>>
>> >> Can we follow the same rule and check whether it is a size-extend=
ing
>> >> aio write in ext4_end_io_dio()? In such cases, we can call
>> >> ext4_end_aio_dio_nolock() synchronously instead of queuing
>> >> the work. I think this will protect us from truncate because we
>> >> are still holding i_mutex and i_alloc_sem.
>> >>
>> >> Jiaying
>> >>
>> >> >
>> >> >
>> >> >> Jiaying
>> >> >>
>> >> >> >
>> >> >> >> =A0We are wondering
>> >> >> >> whether we can extend this idea to buffer write as well. I.=
e., we always
>> >> >> >> allocate an uninitialized extent first during any write and=
 convert it
>> >> >> >> as initialized at the time of end_io callback. This will el=
iminate the need
>> >> >> >> to hold i_mutex lock during direct read because a DIO read =
should never get
>> >> >> >> a block marked initialized before the block has been writte=
n with new data.
>> >> >> >>
>> >> >> >
>> >> >> > Oh I don't think so. For buffered IO, the data is being copi=
ed to
>> >> >> > buffer, direct IO read would first flush what's in page cach=
e to disk,
>> >> >> > then read from disk. So if there is concurrent buffered writ=
e and direct
>> >> >> > read, removing the i_mutex locks from the direct IO path sho=
uld still
>> >> >> > gurantee the right order, without having to treat buffered a=
llocation
>> >> >> > with uninitialized extent/end_io.
>> >> >> >
>> >> >> > The i_mutex lock, from my understanding, is there to protect=
 direct IO
>> >> >> > write to hole and concurrent direct IO read, we should able =
to remove
>> >> >> > this lock for extent based ext4 file.
>> >> >> >
>> >> >> >> We haven't implemented anything yet because we want to ask =
here first to
>> >> >> >> see whether this proposal makes sense to you.
>> >> >> >>
>> >> >> >
>> >> >> > It does make sense to me.
>> >> >> >
>> >> >> > Mingming
>> >> >> >> Regards,
>> >> >> >>
>> >> >> >> Jiaying
>> >> >> >> --
>> >> >> >> To unsubscribe from this list: send the line "unsubscribe l=
inux-ext4" in
>> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-=
info.html
>> >> >> >
>> >> >> >
>> >> >> >
>> >> >
>> >> >
>> >> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> >
>> >
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
