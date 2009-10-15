From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Thu, 15 Oct 2009 13:07:52 -0700
Message-ID: <5df78e1d0910151307p342a0c71x5413fad2202a1daa@mail.gmail.com>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910142214s51a4db0and358fc432225338b@mail.gmail.com>
	 <1255627868.4377.1113.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:44234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935369AbZJOUJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 16:09:07 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n9FK7uvv017100
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 13:07:58 -0700
Received: from gxk8 (gxk8.prod.google.com [10.202.11.8])
	by spaceape10.eur.corp.google.com with ESMTP id n9FK7rei026014
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 13:07:53 -0700
Received: by gxk8 with SMTP id 8so1400217gxk.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 13:07:53 -0700 (PDT)
In-Reply-To: <1255627868.4377.1113.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 15, 2009 at 10:31 AM, Mingming <cmm@us.ibm.com> wrote:
> On Wed, 2009-10-14 at 22:14 -0700, Jiaying Zhang wrote:
>> Mingming,
>>
>
> Hi Jiaying,
>
>> On Wed, Oct 14, 2009 at 11:48 AM, Mingming <cmm@us.ibm.com> wrote:
>> > On Fri, 2009-10-09 at 16:34 -0700, Jiaying Zhang wrote:
>> >> Hello,
>> >>
>> >> Recently, we are evaluating the ext4 performance on a high speed =
SSD.
>> >> One problem we found is that ext4 performance doesn't scale well =
with
>> >> multiple threads or multiple AIOs reading a single file with O_DI=
RECT.
>> >> E.g., with 4k block size, multiple-thread DIO AIO random read on =
ext4
>> >> can lose up to 50% throughput compared to the results we get via =
RAW IO.
>> >>
>> >> After some initial analysis, we think the ext4 performance proble=
m is caused
>> >> by the use of i_mutex lock during DIO read. I.e., during DIO read=
, we grab
>> >> the i_mutex lock in __blockdev_direct_IO because ext4 uses the de=
fault
>> >> DIO_LOCKING from the generic fs code. I did a quick test by calli=
ng
>> >> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext=
4 DIO read
>> >> got 99% performance as raw IO.
>> >>
>> >
>> > This is very interesting...and impressive number.
>> >
>> > I tried to change ext4 to call blockdev_direct_IO_no_locking() dir=
ectly,
>> > but then realize that we can't do this all the time, as ext4 suppo=
rt
>> > ext3 non-extent based files, and uninitialized extent is not suppo=
rt on
>> > ext3 format file.
>> >
>> >> As we understand, the reason why we want to take i_mutex lock dur=
ing DIO
>> >> read is to prevent it from accessing stale data that may be expos=
ed by a
>> >> simultaneous write. We saw that Mingming Cao has implemented a pa=
tch set
>> >> with which when a get_block request comes from direct write, ext4=
 only
>> >> allocates or splits an uninitialized extent. That uninitialized e=
xtent
>> >> will be marked as initialized at the end_io callback.
>> >
>> > Though I need to clarify that with all the patches in mainline, we=
 only
>> > treat new allocated blocks form direct io write to holes, not to w=
rites
>> > to the end of file. I actually have proposed to treat the write to=
 the
>> > end of file also as unintialized extents, but there is some concer=
ns
>> > that this getting tricky with updating inode size when it is async=
 IO
>> > direct IO. So it didn't getting done yet.
>>
>> I read you previous email thread again. As I understand, the main
>> concern for allocating uninitialized blocks in i_size extending writ=
e
>> is that we may end up having uninitialized blocks beyond i_size
>> if the system crashes during write. Can we protect this case by
>> adding the inode into the orphan list in ext4_ext_direct_IO,
>> i.e., same as we have done in ext4_ind_direct_IO?
>>
>
> Sure we could do that, though initially I hoped we could get rid of
> that:)
>
> The tricky part is async direct write to the end of file. By the time
> the IO is completed, the inode may be truncated or extended larger.
> Updating the most "safe" size is the part I haven't thought through y=
et.
>

Ok. I think I understand the problem better now :).

Looking at the __blockdev_direct_IO(), I saw it actually treats
size-extending aio dio write as synchronous and expects the dio to
complete before return (fs/direct-io.c line 1204 and line 1056-1061).
Can we follow the same rule and check whether it is a size-extending
aio write in ext4_end_io_dio()? In such cases, we can call
ext4_end_aio_dio_nolock() synchronously instead of queuing
the work. I think this will protect us from truncate because we
are still holding i_mutex and i_alloc_sem.

Jiaying

>
>
>> Jiaying
>>
>> >
>> >> =A0We are wondering
>> >> whether we can extend this idea to buffer write as well. I.e., we=
 always
>> >> allocate an uninitialized extent first during any write and conve=
rt it
>> >> as initialized at the time of end_io callback. This will eliminat=
e the need
>> >> to hold i_mutex lock during direct read because a DIO read should=
 never get
>> >> a block marked initialized before the block has been written with=
 new data.
>> >>
>> >
>> > Oh I don't think so. For buffered IO, the data is being copied to
>> > buffer, direct IO read would first flush what's in page cache to d=
isk,
>> > then read from disk. So if there is concurrent buffered write and =
direct
>> > read, removing the i_mutex locks from the direct IO path should st=
ill
>> > gurantee the right order, without having to treat buffered allocat=
ion
>> > with uninitialized extent/end_io.
>> >
>> > The i_mutex lock, from my understanding, is there to protect direc=
t IO
>> > write to hole and concurrent direct IO read, we should able to rem=
ove
>> > this lock for extent based ext4 file.
>> >
>> >> We haven't implemented anything yet because we want to ask here f=
irst to
>> >> see whether this proposal makes sense to you.
>> >>
>> >
>> > It does make sense to me.
>> >
>> > Mingming
>> >> Regards,
>> >>
>> >> Jiaying
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
