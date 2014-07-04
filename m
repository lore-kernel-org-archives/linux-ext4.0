From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 16:18:41 -0600
Message-ID: <D1E29C34-308C-4906-A697-BB383600226B@dilger.ca>
References: <20140626203052.GA9449@xo-6d-61-c0.localdomain> <20140627024659.GF6826@thunk.org> <20140629202516.GA11430@amd.pavel.ucw.cz> <20140629210428.GD2162@thunk.org> <20140630064644.GA23079@amd.pavel.ucw.cz> <20140630134313.GA3753@thunk.org> <20140704102307.GA19252@amd.pavel.ucw.cz> <20140704121119.GB10514@thunk.org> <20140704172104.GA4877@xo-6d-61-c0.localdomain> <9BEA347C-2246-4746-95A4-0E00E0369816@dilger.ca> <20140704203309.GA28107@amd.pavel.ucw.cz>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_95B7E185-FAE4-4999-971B-994D1E486D8C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34840 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800AbaGDWSk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 18:18:40 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so2449179pab.15
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jul 2014 15:18:39 -0700 (PDT)
In-Reply-To: <20140704203309.GA28107@amd.pavel.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_95B7E185-FAE4-4999-971B-994D1E486D8C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 4, 2014, at 2:33 PM, Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2014-07-04 13:17:37, Andreas Dilger wrote:
>> Maybe it is worthwhile to improve this error message to be:
>>=20
>>    EXT4-fs (sda3): initial error at time 1401714179: ...
>=20
> I'm glad you suggested it. I actually done a patch before reading
> this. What about:

Looks good to me.  There have been a few users confused by these =
messages
already, so it is nice to make them a bit more clear.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> Make it clear that values printed are times, and that it is error
> since last fsck. Also add note about fsck version required.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b9b9aab..3423947 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2809,10 +2809,11 @@ static void print_daily_error_info(unsigned =
long arg)
> 	es =3D sbi->s_es;
>=20
> 	if (es->s_error_count)
> -		ext4_msg(sb, KERN_NOTICE, "error count: %u",
> +		/* fsck newer than v1.41.13 is needed to clean this =
condition. */
> +		ext4_msg(sb, KERN_NOTICE, "error count since last fsck: =
%u",
> 			 le32_to_cpu(es->s_error_count));
> 	if (es->s_first_error_time) {
> -		printk(KERN_NOTICE "EXT4-fs (%s): initial error at %u: =
%.*s:%d",
> +		printk(KERN_NOTICE "EXT4-fs (%s): initial error at time =
%u: %.*s:%d",
> 		       sb->s_id, le32_to_cpu(es->s_first_error_time),
> 		       (int) sizeof(es->s_first_error_func),
> 		       es->s_first_error_func,
> @@ -2826,7 +2827,7 @@ static void print_daily_error_info(unsigned long =
arg)
> 		printk("\n");
> 	}
> 	if (es->s_last_error_time) {
> -		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: =
%.*s:%d",
> +		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: =
%.*s:%d",
> 		       sb->s_id, le32_to_cpu(es->s_last_error_time),
> 		       (int) sizeof(es->s_last_error_func),
> 		       es->s_last_error_func,
>=20
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) =
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


Cheers, Andreas






--Apple-Mail=_95B7E185-FAE4-4999-971B-994D1E486D8C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU7coQXKl2rkXzB/gAQLT8RAAuO0REQoFcysckKbVse1eMb2QZ5W7dZhy
v5H90v/e8fh5QLl0lTlE+JPuyd3eoqJC466+jelURJt1FArS6C6wP2Kdg3IPiwSj
s2nPGybR7Iyrrro60mMzRs4CPzwSlqJizvCt5IZw7Pw16rwo2vb/w7/W+t6hrPVB
esOto0XyM+6VifHozX5YC7PB/z7cYN3Kd2FeijWwHELhDUp+REVsHkIdSW1uD9F/
NVdwIM+EMLMRvBLW3roVuY2+EBY1I+f5mWGKwBuC5tszhe7+281pLvUNl4pwG8rD
73g8WeCYTILO1bHg/fYe+pGJZJwBldQy/WjDY9P9ip/EgVoaQyMbTnkLZBLT1mz/
8fH7G5I1FNDRcJtuhrWeYJvZ1ti4juGvlhJvMa8m4y8IpPHeDWEpaRBs2paEOXx9
oVb950EglQ1yQiySbSh9jfAOa9uWLL6yvwueH4oa2R1ayrGNjEFCCPXTaxsMLYdU
gNCDl2H9ZqAhoOY2AIuFjX+nd49UwPML3arKsAqnx+b7AedmXflon6sTwXWJgaiC
WvMXjRfyLWrkKdDHX2Jp+rtGDaRDZXxUeesnR2jJYNE3Q72MzZqM6CrC8boWvg5u
/Uw/dbvdiBLilnqIXXfxxt8YGjRmORkqRuZgE/gWItLYznu400WNVx7RDfmMO511
/oKXIqfwb7w=
=h90w
-----END PGP SIGNATURE-----

--Apple-Mail=_95B7E185-FAE4-4999-971B-994D1E486D8C--
