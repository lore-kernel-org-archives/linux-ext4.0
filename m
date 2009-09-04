From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space in
	failure
Date: Fri, 4 Sep 2009 11:35:56 +0800
Message-ID: <6149e97b0909032035w45c5a866x1b48a78670e3dd20@mail.gmail.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>
	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com>
	 <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com>
	 <87f94c370909030648n84c5814kb04cb6d5e17b3d6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:56430 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZIDDfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 23:35:54 -0400
Received: by pxi32 with SMTP id 32so388546pxi.25
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2009 20:35:56 -0700 (PDT)
In-Reply-To: <87f94c370909030648n84c5814kb04cb6d5e17b3d6e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 3, 2009 at 9:48 PM, Greg Freemyer<greg.freemyer@gmail.com> =
wrote:
> On Thu, Sep 3, 2009 at 1:13 AM, Peng Tao<bergwolf@gmail.com> wrote:
>> Hi, Greg,
>>
>> On Thu, Sep 3, 2009 at 4:59 AM, Greg Freemyer<greg.freemyer@gmail.co=
m> wrote:
>>> Peng,
>>>
>>> I have not looked at the code very closely, but can you tell me whe=
re
>>> a file corruption can take place? =C2=A0 Not completing the replace=
ment of
>>> extents with donor extents is one thing. =C2=A0Corrupting the origi=
nal file
>>> contents is another.
>> The file corruption is mainly because of the half done replacement.
>>
>> My test case is here:
>> http://marc.info/?l=3Dlinux-ext4&m=3D124992522305319&w=3D2
>>
>> With Akira's previous patch
>> (http://marc.info/?l=3Dlinux-ext4&m=3D124937430627867&w=3D2),
>> EXT4_IOC_MOVE_EXT does not panic the kernel any more. But it leaves
>> the orig file's extent tree corrupted.
>
> Is this highly repeatable, e4defrag using EXT4_IOC_MOVE_EXT corrupts
> sparse files?
It is the EXT4_IOC_MOVE_EXT ioctl corrupts sparse files because it
doesn't handle well with file holes.
The e4defrag program  loops to call EXT4_IOC_MOVE_EXT for each
non-continuous parts of a file, so it doesn't expose file holes to
kernel.
But since the ioctl interface is publicly usable, I do suggest making
it behave better, at lease don't bug the kernel, because I did hit
null pointer reference in my last time testing the new ioctl. So IMHO,
Akira's previous patch (http://patchwork.ozlabs.org/patch/30707/) is
really necessary.

>
> If so, it seems like a pretty major bug that will be exposed to
> userspace when 2.6.31 goes final.
>
> It seems to me at a minimum a Kconfig option should be added to enabl=
e
> the ioctl to userspace and that it should have depends on EXPERIMENTA=
L
> and default to NO for now.
>
> We don't want people thinking that this feature is stable in 2.6.31.
I do agree that the feature is still unstable ATM.

>
> Greg
> --
> Greg Freemyer
> Head of EDD Tape Extraction and Processing team
> Litigation Triage Solutions Specialist
> http://www.linkedin.com/in/gregfreemyer
> Preservation and Forensic processing of Exchange Repositories White P=
aper -
> <http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.ht=
ml>
>
> The Norcross Group
> The Intersection of Evidence & Technology
> http://www.norcrossgroup.com
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
