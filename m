From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Thu, 23 Jun 2011 07:27:13 -0400
Message-ID: <BANLkTin4G1ERu+mfgf_9KFZNXtDd2kuYFg@mail.gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org>
 <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
 <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab1FWL1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 07:27:44 -0400
Received: by bwz15 with SMTP id 15so1434210bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jun 2011 04:27:43 -0700 (PDT)
In-Reply-To: <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 23, 2011 at 7:16 AM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> On Tue, Jun 21, 2011 at 7:28 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wro=
te:
>> 2011/06/18 16:19, Andreas Dilger wrote:
>>>
>>> I was thinking about this, and am wondering if it makes sense to ha=
ve an
>>> absolute score for fragmentation
>>> instead of a relative one?
>>>
>>> By absolute I mean something like fragments per MB or similar. A ba=
d score
>>> might be anything> =A01. For
>>> files smaller than 1 MB in size it would scale the ratio to the equ=
ivalent
>>> if the file was 1MB in size
>>> (e.g. a 16kB file with 4 fragments would have a score of 256, which=
 is
>>> clearly bad). =A0Large files can
>>> have a score much less than 1, which is good.
>>
>> I think fragments per MB is easy to understand. I will fix the libra=
ry
>> function
>> to "double e2p_get_fragscore(int fd)". To return fragments per MB, i=
t will
>> get the number of extents and the total length of extents except the
>> following
>> special cases:
>> - The extent whose initialize status is different from the next exte=
nt
>> - There is a hole between the extent and the next extent
>> - The extent is a tail
>
> For a sparse file, can you explain why you treat the head and tail
> extents of a block group differently?
>
> The issue is totally symetric in my mind, so either include both or
> exclude both in my opinion. =A0The above description only excludes th=
e
> block group tail extents.
>
> Greg

I forgot to say, fragments per MB is not a large enough unit in my mind=
=2E

A storage system that can transfer 100MB / sec , but takes 5 msecs to
seek and do a half rotation of the platter would spend 33% of its time
seeking if it had 1MB contiguous sections of data all over the drive.

=46ragments per max extent really seems the only logical thng for
e4defrag to use in my mind.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
