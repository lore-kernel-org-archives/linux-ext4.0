From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: what happened with dccaf33fa37 "ext4: flush any pending end_io
 requests before DIO" for 3.0?
Date: Mon, 19 Mar 2012 10:10:11 -0700
Message-ID: <CAFgt=MCXRzLx+s1mthr1oD=Pj=HQ5kxnOdbtX8Q9=wSeZ41u2w@mail.gmail.com>
References: <4ED6942F.7070006@msgid.tls.msk.ru>
	<4F4CBDA1.1080302@msgid.tls.msk.ru>
	<4F6459F2.8010403@msgid.tls.msk.ru>
	<20120319164256.GB10561@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: gregkh@linuxfoundation.org, stable@kernel.org,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>, Theodore Tso <tytso@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42887 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab2CSRKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 13:10:12 -0400
Received: by yhmm54 with SMTP id m54so5685088yhm.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2012 10:10:11 -0700 (PDT)
In-Reply-To: <20120319164256.GB10561@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 9:42 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 17-03-12 13:31:30, Michael Tokarev wrote:
>> Ping?
>>
>> Maybe just a one-line reply isn't THAT difficult?
Sorry for the slow response. I am not sure what happened to this patch.
Ted, do you know what we need to do to get this patch to the
stable release?

Jiaying

>>
>> We've a data corruption bug in current longterm stable kernel
>> series which is known and has a fix and tagged for -stable for
>> over half a year already...
> =A0Greg, any idea why this patch was not included?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
>> On 28.02.2012 15:42, Michael Tokarev wrote:
>> > Is there something wrong with my question? =A0I asked it 1.5 month=
s ago...
>> >
>> > Meanwhile, we're using this patch on our database server since
>> > Aug-2011, and it appears to work correctly - direct and buffered
>> > I/O works together without surprizes. =A0Without this patch, I see
>> > unexpected results.
>> >
>> > Thanks,
>> >
>> > /mjt
>> >
>> > On 01.12.2011 00:38, Michael Tokarev wrote:
>> >> Hello.
>> >>
>> >> Back in August 2011, a commit has been tagged to be included
>> >> into stable, this one:
>> >>
>> >> commit dccaf33fa37a1bc5d651baeb3bfeb6becb86597b
>> >> Author: Jiaying Zhang <jiayingz@google.com>
>> >> Date: =A0 Fri Aug 19 19:13:32 2011 -0400
>> >>
>> >> =A0 =A0 ext4: flush any pending end_io requests before DIO reads =
w/dioread_nolock
>> >>
>> >> =A0 =A0 There is a race between ext4 buffer write and direct_IO r=
ead with
>> >> =A0 =A0 dioread_nolock mount option enabled. The problem is that =
we clear
>> >> =A0 =A0 PageWriteback flag during end_io time but will do
>> >> =A0 =A0 uninitialized-to-initialized extent conversion later with=
 dioread_nolock.
>> >> =A0 =A0 If an O_direct read request comes in during this period, =
ext4 will return
>> >> =A0 =A0 zero instead of the recently written data.
>> >>
>> >> =A0 =A0 This patch checks whether there are any pending uninitial=
ized-to-initialized
>> >> =A0 =A0 extent conversion requests before doing O_direct read to =
close the race.
>> >> =A0 =A0 Note that this is just a bandaid fix. The fundamental iss=
ue is that we
>> >> =A0 =A0 clear PageWriteback flag before we really complete an IO,=
 which is
>> >> =A0 =A0 problem-prone. To fix the fundamental issue, we may need =
to implement an
>> >> =A0 =A0 extent tree cache that we can use to look up pending to-b=
e-converted extents.
>> >>
>> >> =A0 =A0 Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>> >> =A0 =A0 Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> >> =A0 =A0 Cc: stable@kernel.org
>> >>
>> >>
>> >> There was one more ext4 commit at that time, which made its way i=
nto
>> >> stable but this one did not.
>> >>
>> >> I wonder if the reason for that was the fact that it needed a sma=
ll
>> >> "backport" for 3.0, since in 3.1+ the code has been moved into an=
other
>> >> file, and the context is slightly different. =A0In that case, att=
ached
>> >> is the "backport" which we use with 3.0.x since that time.
>> >>
>> >> Thanks!
>> >>
>> >> /mjt
>> >
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
