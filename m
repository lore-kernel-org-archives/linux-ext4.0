From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 9 Dec 2010 14:38:00 -0600
Message-ID: <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0__31257.5244381607$1291927139$gmane$org@mail.gmail.com>
References: <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
 <20101209180111.GF2921@thunk.org> <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
 <20101209201359.GG2921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitzer@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Matt <jackdachef@gmail.com>, Milan Broz <mbroz@r
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:52031 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab0LIUiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Dec 2010 15:38:23 -0500
In-Reply-To: <20101209201359.GG2921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 9, 2010 at 2:13 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Dec 09, 2010 at 12:10:58PM -0600, Jon Nelson wrote:
>>
>> You should be OK, there. Are you using encryption or no?
>> I had difficulty replicating the issue without encryption.
>
> Yes, I'm using encryption. =C2=A0LUKS with aes-xts-plain-sha256, and =
then
> LVM on top of LUKS.

Hmm.
The cipher is listed as:
aes-cbc-essiv:sha256

>> > If you can point out how to query pgsql_tmp (I'm using a completel=
y
>> > default postgres install), that would be helpful, but I don't thin=
k it
>> > would be going anywhere else.
>>
>> Normally it's /var/lib/pgsql/data/pgsql_tmp (or
>> /var/lib/postgres/data/pgsql_tmp in your case). By placing
>> /var/lib/{postgresql,pgsql}/data on the LUKS + ext4 volume, on both
>> openSUSE 11.3 and Kubuntu, I was able to replicate the problem easil=
y,
>> in VirtualBox. I can give qemu a try. In both cases I was using a
>> 2.6.37x kernel.
>
> Ah, I'm not using virtualization. =C2=A0I'm running on a X410 laptop,=
 on
> raw hardware. =C2=A0Perhaps virtualization slows things down enough t=
hat it
> triggers? =C2=A0Or maybe you're running with a more constrained memor=
y than
> I? =C2=A0How much memory do you have configured in your VM?

512MB.

'free' reports 75MB, 419MB free.

I originally noticed the problem on really real hardware (thinkpad
T61p), however.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
