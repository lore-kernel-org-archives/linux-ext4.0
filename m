From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Wed, 14 Oct 2009 14:42:51 -0700
Message-ID: <5df78e1d0910141442g680edac9m6bce0f9eb21f8ea6@mail.gmail.com>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910141248h1f537863n97991585e6147ca7@mail.gmail.com>
	 <1255553852.4377.63.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:36248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZJNVoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 17:44:04 -0400
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id n9ELgssu024426
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 22:42:55 +0100
Received: from yxe37 (yxe37.prod.google.com [10.190.2.37])
	by zps76.corp.google.com with ESMTP id n9ELgpDI007066
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 14:42:51 -0700
Received: by yxe37 with SMTP id 37so238458yxe.31
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 14:42:51 -0700 (PDT)
In-Reply-To: <1255553852.4377.63.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 14, 2009 at 1:57 PM, Mingming <cmm@us.ibm.com> wrote:
> On Wed, 2009-10-14 at 12:48 -0700, Jiaying Zhang wrote:
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
>>
>> Hmm, do you mean the filemap_write_and_wait_range() in
>> __blockdev_direct_IO?
>
> yes, that's the one to flush the page cache before direct read.
>
I don't think that function is called with DIO_NO_LOCKING.
Also, if we no longer hold i_mutex lock during dio read, I think
there is a time window that a buffer write can allocate an
initialize block after dio read flushes page cache but
before it calls get_block. Then that dio read can get that
initialized block with stale data.

Jiaying

>> Or do we flush page cache after calling
>> get_block in dio read?
>>
>> Jiaying
>>
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
>>
>>
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
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
