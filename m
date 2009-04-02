From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Date: Thu, 2 Apr 2009 22:29:05 +0400
Message-ID: <a4423d670904021129s61ee55bfh584dbe7bc4322929@mail.gmail.com>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
	 <20090402055356.GC10642@mit.edu>
	 <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com>
	 <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com>
	 <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com>
	 <49D4BDF2.2070102@ph.tum.de> <20090402145436.GF10642@mit.edu>
	 <49D4D74F.1020904@ph.tum.de> <20090402154123.GG10642@mit.edu>
	 <49D4F044.1040306@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:55990 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZDBS3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 14:29:09 -0400
In-Reply-To: <49D4F044.1040306@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/4/2 Thiemo Nagel <thiemo.nagel@ph.tum.de>:
> Theodore Tso wrote:
>>
>> On Thu, Apr 02, 2009 at 05:18:39PM +0200, Thiemo Nagel wrote:
>>>
>>> Theodore Tso wrote:
>>>>
>>>> On Thu, Apr 02, 2009 at 03:30:26PM +0200, Thiemo Nagel wrote:
>>>>>
>>>>> When I added the block range checks, initially I was assuming tha=
t
>>>>> when EXTENTS_FL is not set, the inode->i_data *always* contains
>>>>> references to further blocks. =C2=A0Ted showed me wrong and added=
 the
>>>>> condition
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ISREG() || ISDIR() || ( ISLNK() && !is=
_fast_symlink() )
>>>>>
>>>>> before that assumption can be made. =C2=A0But maybe we need some =
further
>>>>> restraints?
>>>>
>>>> It's a endian-problem; we're missing le32_to_cpu() in that patch.
>>>> Sparc is big-endian.
>>>
>>> Sorry for that.
>>
>> Could you also fix the types? =C2=A0bref should have a type of __le3=
2, not
>> unsigned int, and when you pass in the reference to
>> __ext4_check_blockref(), there was an inappropriate cast to unsigned
>> int which hid kernel's natural type checking to catch these sorts of
>> problems.
>
> So I was really asking for things to go wrong... =C2=A0:-(
> I hope the attached patch handles conversion and types in the right w=
ay.
> =C2=A0It's compile-tested only, the current ext4 tree crashes my mach=
ine.

It works fine, thanks.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
