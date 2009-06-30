From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: Massive corruption on RAID0
Date: Tue, 30 Jun 2009 14:28:09 -0400
Message-ID: <170fa0d20906301128x3eef7033m91126f3658eadc0c@mail.gmail.com>
References: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>
	 <4A48355D.5040001@redhat.com>
	 <298610bb0906290812t249c7e52l80e57af36bd0e80c@mail.gmail.com>
	 <4A4A3065.4020202@redhat.com>
	 <87f94c370906300942p7c5f576cgbb8c065625cf1716@mail.gmail.com>
	 <4A4A415A.1070207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	=?ISO-8859-2?Q?Krzysztof_Kosi=F1ski?= <tweenk.pl@gmail.com>,
	linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:43785 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZF3S2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jun 2009 14:28:08 -0400
Received: by ewy6 with SMTP id 6so438850ewy.37
        for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2009 11:28:10 -0700 (PDT)
In-Reply-To: <4A4A415A.1070207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/6/30 Eric Sandeen <sandeen@redhat.com>:
> Greg Freemyer wrote:
>> 2009/6/30 Eric Sandeen <sandeen@redhat.com>:
>>> Krzysztof Kosi=F1ski wrote:
>> <snip>
>>>>>> By the way, is there some way to have RAID0-like functionality w=
ith
>>>> write barriers?
>>> Mirrors can pass barriers, IIRC, but not stripes (IIRC...) - I don'=
t
>>> know if any work is being done to address this.
>>>
>> I'm pretty sure mdraid is not attempting to address it.
>>
>> The issue is that barriers with a single drive can simply be sent to
>> the drive for it to do the heavy lifting.
>>
>> With raid-0, it is much more difficult.
>>
>> ie. you send a barrier to 2 different drives. =A0One drive takes 30
>> milliseconds to flush the pre-barrier queue to disk and then continu=
es
>> working on the post barrier data . =A0The other drive takes 500
>> milliseconds to do the same. =A0The end result is out of sync barrie=
rs.
>> Not at all what the filesystem expects.
>>
>> The only reliable solution is to disable write caching on the drives=
=2E
>> Of course you don't need barriers then.
>
> Agreed this is the best solution at least for now. =A0But, the dm fol=
ks
> are apparently working on some sort of barrier solution for stripes, =
I
> think. =A0I don't know the details, perhaps I should.... :)

Yes, DM's stripe target has full barrier support in the latest
2.6.31-rc1.  You can create a striped LV using:
lvcreate --stripes STRIPES --stripsesize STRIPESIZE ...

It should be noted that 2.6.31-rc1 had a small bug that causes
"misaligned" warnings to appear when activating DM devices.  These
warnings can be ignored and obviously have nothing to do with barriers
(they are related to DM's new support for the topology
infrastructure).  That warnings bug has been fixed and will likely be
pulled in for 2.6.31-rc2.

Mike

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
