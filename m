From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Wed, 17 Feb 2010 13:09:30 -0500
Message-ID: <87f94c371002171009i2a8ffe2aib43b82c1cf65104@mail.gmail.com>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
	 <20100216185452.GE3153@quack.suse.cz>
	 <4B7BAA70.9070605@jp.fujitsu.com> <20100217164933.GC5337@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44019 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0BQSJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 13:09:36 -0500
Received: by vws11 with SMTP id 11so12058vws.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 10:09:34 -0800 (PST)
In-Reply-To: <20100217164933.GC5337@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 17, 2010 at 11:49 AM,  <tytso@mit.edu> wrote:
> On Wed, Feb 17, 2010 at 05:36:00PM +0900, Toshiyuki Okajima wrote:
>>
>> The reason that I wanted to change the journaling interface into jbd=
2 were:
>> - the most of my customers use linux for Mission Critical (M.C.).
>> - M.C. users want the filesystems which have more integrity for thei=
r data.
>> - I think we should not recommend ext4 to M.C. users because
>> =A0 for M.C. users, ext4 is still unstable filesystem.
>> =A0 Therefore I want to let M.C. users use ext3 for the present.
>> - it is not easy to maintain both jbd and jbd2, so
>> =A0 I thought it was easy to solve it by unifying the journaling int=
erfaces
>> =A0 into ext4.
>
> But if they are mission critical users, why would they be willing to
> accept changes to the jbd2 layer, and the necessary changes to ext3 s=
o
> it can use jbd2? =A0Any time you add changes, you will be causing a
> certain amount of instability and risk. =A0So the question is, what a=
re
> your users willing to tolerate?
>
> Some important questions to ask:
>
> 1) Is the problem psychological? =A0i.e., is the problem that it is
> *called* ext4? =A0After all, ext4 is derived from ext3, so if they ar=
e
> willing to accept new features backported into ext3 (i.e., journal
> checksums) and the risks associated with making changes to add new
> features, why are they not willing to accept ext4?
>
> 2) If it is a question of risk, how many changes are they willing to
> accept? =A0I will note that if you don't enable extents, and disable
> delayed allocation, you can significantly decrease the risk of using
> ext4. =A0(Essentially at that point the only major change is the bloc=
k
> allocation code and the changes to use jbd2.)
>
> 3) How much testing do you need to do before it would be considered
> acceptable for your Mission Critical users? =A0Or is it a matter of t=
ime
> to allow other users to be the "guinea pigs"? =A0:-)
>
>> OK. I see.
>> (ext3 is already stable filesystem, so, we should not change
>> =A0ext3 drastically.)
>
> Well, certainly, *any* change is going to risk destablizing the file
> system. =A0Isn't that the argument why you are concerned about whethe=
r
> ext4 is ready for your M.C. users? =A0One of the reasons why we forke=
d
> jbd2 from jbd was precisely because of these sorts of concerned. =A0S=
o
> if you switch ext3 to use jbd2, would that not increase the risk to
> your M.C. users?
>
> Best regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0- Ted

Having little knowledge on my part, it sounds like it is time to open
up jdb3 for leading edge development and turn jdb2 into the new stable
platform and move jdb into legacy status.

If it really does only have one user at this time jdb is basically
just legacy at this point anyway.

Greg



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
