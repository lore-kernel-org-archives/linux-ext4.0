From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Wed, 14 Oct 2009 22:14:30 -0700
Message-ID: <5df78e1d0910142214s51a4db0and358fc432225338b@mail.gmail.com>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:52891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZJOFPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 01:15:41 -0400
Received: from spaceape8.eur.corp.google.com (spaceape8.eur.corp.google.com [172.28.16.142])
	by smtp-out.google.com with ESMTP id n9F5EXjb024774
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 22:14:34 -0700
Received: from yxe7 (yxe7.prod.google.com [10.190.2.7])
	by spaceape8.eur.corp.google.com with ESMTP id n9F5EUGP004256
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 22:14:31 -0700
Received: by yxe7 with SMTP id 7so507576yxe.25
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 22:14:30 -0700 (PDT)
In-Reply-To: <1255546117.4377.62.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming,

On Wed, Oct 14, 2009 at 11:48 AM, Mingming <cmm@us.ibm.com> wrote:
> On Fri, 2009-10-09 at 16:34 -0700, Jiaying Zhang wrote:
>> Hello,
>>
>> Recently, we are evaluating the ext4 performance on a high speed SSD=
=2E
>> One problem we found is that ext4 performance doesn't scale well wit=
h
>> multiple threads or multiple AIOs reading a single file with O_DIREC=
T.
>> E.g., with 4k block size, multiple-thread DIO AIO random read on ext=
4
>> can lose up to 50% throughput compared to the results we get via RAW=
 IO.
>>
>> After some initial analysis, we think the ext4 performance problem i=
s caused
>> by the use of i_mutex lock during DIO read. I.e., during DIO read, w=
e grab
>> the i_mutex lock in __blockdev_direct_IO because ext4 uses the defau=
lt
>> DIO_LOCKING from the generic fs code. I did a quick test by calling
>> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext4 D=
IO read
>> got 99% performance as raw IO.
>>
>
> This is very interesting...and impressive number.
>
> I tried to change ext4 to call blockdev_direct_IO_no_locking() direct=
ly,
> but then realize that we can't do this all the time, as ext4 support
> ext3 non-extent based files, and uninitialized extent is not support =
on
> ext3 format file.
>
>> As we understand, the reason why we want to take i_mutex lock during=
 DIO
>> read is to prevent it from accessing stale data that may be exposed =
by a
>> simultaneous write. We saw that Mingming Cao has implemented a patch=
 set
>> with which when a get_block request comes from direct write, ext4 on=
ly
>> allocates or splits an uninitialized extent. That uninitialized exte=
nt
>> will be marked as initialized at the end_io callback.
>
> Though I need to clarify that with all the patches in mainline, we on=
ly
> treat new allocated blocks form direct io write to holes, not to writ=
es
> to the end of file. I actually have proposed to treat the write to th=
e
> end of file also as unintialized extents, but there is some concerns
> that this getting tricky with updating inode size when it is async IO
> direct IO. So it didn't getting done yet.

I read you previous email thread again. As I understand, the main
concern for allocating uninitialized blocks in i_size extending write
is that we may end up having uninitialized blocks beyond i_size
if the system crashes during write. Can we protect this case by
adding the inode into the orphan list in ext4_ext_direct_IO,
i.e., same as we have done in ext4_ind_direct_IO?

Jiaying

>
>> =A0We are wondering
>> whether we can extend this idea to buffer write as well. I.e., we al=
ways
>> allocate an uninitialized extent first during any write and convert =
it
>> as initialized at the time of end_io callback. This will eliminate t=
he need
>> to hold i_mutex lock during direct read because a DIO read should ne=
ver get
>> a block marked initialized before the block has been written with ne=
w data.
>>
>
> Oh I don't think so. For buffered IO, the data is being copied to
> buffer, direct IO read would first flush what's in page cache to disk=
,
> then read from disk. So if there is concurrent buffered write and dir=
ect
> read, removing the i_mutex locks from the direct IO path should still
> gurantee the right order, without having to treat buffered allocation
> with uninitialized extent/end_io.
>
> The i_mutex lock, from my understanding, is there to protect direct I=
O
> write to hole and concurrent direct IO read, we should able to remove
> this lock for extent based ext4 file.
>
>> We haven't implemented anything yet because we want to ask here firs=
t to
>> see whether this proposal makes sense to you.
>>
>
> It does make sense to me.
>
> Mingming
>> Regards,
>>
>> Jiaying
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
