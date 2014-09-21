From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: Sun, 21 Sep 2014 18:08:28 -0400
Message-ID: <BAY179-W560EC72EB98547138373E3FDB20@phx.gbl>
References: <20140921175515.GA30646@thunk.org>,<20140921210416.27127.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "linux@horizon.com" <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc2s8.hotmail.com ([65.54.190.83]:62765 "EHLO
	BAY004-OMC2S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaIUWI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Sep 2014 18:08:28 -0400
In-Reply-To: <20140921210416.27127.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is protection against hash DoS important for local on-disk format? I ca=
n't come up=A0
with a scenario, but maybe there is one. =A0The kinds of DoS contemplat=
ed are=A0
really Google-scale, not really at the scale of ext4 directories, imo.

I ask because if hash perf is the main goal here, then CityHash and par=
ticularly SpookyHash=A0
are better candidates. The latter has good performance even on legacy A=
RMv5 hardware.=A0

+Reardon


----------------------------------------
> Date: Sun, 21 Sep 2014 17:04:16 -0400
> From: linux@horizon.com
> To: linux@horizon.com; tytso@mit.edu
> Subject: Re: [RFC] mke2fs -E hash_alg=3Dsiphash: any interest?
> CC: linux-ext4@vger.kernel.org
>
>> I'm certainly not against adding a new hash function. The reality is
>> that it would be quite a while before we could turn it on by default=
,
>> because of the backwards compatibility concerns.
>
> Well, yes, obviously! My itch is just that I want to use it myself;
> I prefer it for security and cleanliness reasons. The benchmarks are
> mostly to prove that it isn't slower.
>
>> The question I would ask is whether we can show an anctual performan=
ce
>> improvement with the hash being used in situ.
>
> I quite agree, but I'll have to have a working patch before such
> a test can be made.
>
> One things I'm coming across immediately that I have to ask for
> design guidance on is the hash algorithm number assignment:
>
> - Should I leave room for more hashes with a signed/unsigned distinct=
ion,
> or should I assume that's a historical kludge that won't be perpetuat=
ed?
> SipHash is defined on a byte string, so there isn't really a signed
> version.
> - Should I use a new EXT2_HASH_SIPHASH_62 =3D 6, or should I
> renumber the (internal-only) EXT2_HASH_*_UNSIGNED values and use
> EXT2_HASH_SIPHASH_4_2 =3D 4?
>
> None of this is truly final, but it would make my life easier if I
> didn't have to change it on my test filesystems too often.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
