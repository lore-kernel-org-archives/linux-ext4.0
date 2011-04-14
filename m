From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 20:13:53 +0100
Message-ID: <4DA74771.5010103@draigBrady.com>
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>	<4DA7182B.8050409@draigBrady.com> <878vvcspz0.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-ext4@vger.kernel.org,
	coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:3829 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759172Ab1DNTPh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 15:15:37 -0400
In-Reply-To: <878vvcspz0.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 14/04/11 18:27, Jim Meyering wrote:
>=20
> FYI, I see the same failure now using ext3 (and but not w/ext4)
> with rawhide's 2.6.39-0.rc2.git0.0.fc16.x86_64:
>=20
>   + df -t ext3 .

Not with ext3 ...

>   + mkfs -t ext4 -F blob

=2E.. but with ext4 loop back

>   + perl -e 'BEGIN { $n =3D 1 * 1024; *F =3D *STDOUT }' -e 'for (1..1=
) { sysseek (*F, $n, 1)' -e '&& syswrite (*F, chr($_)x$n) or die "$!"}'

>   + cp --sparse=3Dalways j1 j2
>   + cmp j1 j2
>   j1 j2 differ: char 1, line 1     <<<<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

But there was no preallocation done above.
So this was the original sync issue, which doesn't seem to be working :=
(
Is there a chance the rawhide kernel hasn't included that change?
Unlikely as it's 2.6.39-rc2.

cheers,
P=E1draig.

p.s. I will do some checking with ext3 to ensure everything is OK
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
