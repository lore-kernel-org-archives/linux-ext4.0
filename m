From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space in
	failure
Date: Thu, 3 Sep 2009 09:48:00 -0400
Message-ID: <87f94c370909030648n84c5814kb04cb6d5e17b3d6e@mail.gmail.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>
	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com>
	 <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:53419 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZICNr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 09:47:59 -0400
Received: by qyk11 with SMTP id 11so1078340qyk.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2009 06:48:01 -0700 (PDT)
In-Reply-To: <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 3, 2009 at 1:13 AM, Peng Tao<bergwolf@gmail.com> wrote:
> Hi, Greg,
>
> On Thu, Sep 3, 2009 at 4:59 AM, Greg Freemyer<greg.freemyer@gmail.com=
> wrote:
>> Peng,
>>
>> I have not looked at the code very closely, but can you tell me wher=
e
>> a file corruption can take place? =A0 Not completing the replacement=
 of
>> extents with donor extents is one thing. =A0Corrupting the original =
file
>> contents is another.
> The file corruption is mainly because of the half done replacement.
>
> My test case is here:
> http://marc.info/?l=3Dlinux-ext4&m=3D124992522305319&w=3D2
>
> With Akira's previous patch
> (http://marc.info/?l=3Dlinux-ext4&m=3D124937430627867&w=3D2),
> EXT4_IOC_MOVE_EXT does not panic the kernel any more. But it leaves
> the orig file's extent tree corrupted.

Is this highly repeatable, e4defrag using EXT4_IOC_MOVE_EXT corrupts
sparse files?

If so, it seems like a pretty major bug that will be exposed to
userspace when 2.6.31 goes final.

It seems to me at a minimum a Kconfig option should be added to enable
the ioctl to userspace and that it should have depends on EXPERIMENTAL
and default to NO for now.

We don't want people thinking that this feature is stable in 2.6.31.

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
