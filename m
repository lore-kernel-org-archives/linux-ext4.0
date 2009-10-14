From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Wed, 14 Oct 2009 12:48:03 -0700
Message-ID: <5df78e1d0910141248h1f537863n97991585e6147ca7@mail.gmail.com>
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
Received: from smtp-out.google.com ([216.239.33.17]:61733 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249AbZJNTtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 15:49:16 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id n9EJm6KV020658
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 20:48:07 +0100
Received: from ywh34 (ywh34.prod.google.com [10.192.8.34])
	by wpaz1.hot.corp.google.com with ESMTP id n9EJm4Vf016369
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 12:48:04 -0700
Received: by ywh34 with SMTP id 34so142214ywh.1
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 12:48:04 -0700 (PDT)
In-Reply-To: <1255546117.4377.62.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

Hmm, do you mean the filemap_write_and_wait_range() in
__blockdev_direct_IO? Or do we flush page cache after calling
get_block in dio read?

Jiaying

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
