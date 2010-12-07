From: Chris Mason <chris.mason@oracle.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt barrier support is effective)
Date: Tue, 07 Dec 2010 15:02:01 -0500
Message-ID: <1291751698-sup-9297@think>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com> <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com> <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com> <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:22252 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0LGUCl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 15:02:41 -0500
In-reply-to: <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -0500:
> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> >> postgresql errors. Typically, header corruption but from the limit=
ed
> >> visibility I've had into this via strace, what I see is zeroed pag=
es
> >> where there shouldn't be.
> >
> > This sounds a lot like a bug higher up than dm-crypt. =C2=A0Zeros t=
end to
> > come from some piece of code explicitly filling a page with zeros, =
and
> > that often happens in the corner cases for O_DIRECT and a few other
> > places in the filesystem.
> >
> > Have you tried triggering this with a regular block device?
>=20
> I just tried the whole set of tests, but with /dev/sdb directly (as
> ext4) without any crypt-y bits.
> It takes more iterations but out of 6 tests I had one failure: same
> type of thing, 'invalid page header in block ....'.
>=20
> I can't guarantee that it is a full-page of zeroes, just what I saw
> from the (limited) stracing I did.

=46antastic. Now for our usual suspects:

1) Is postgres using O_DIRECT?  If yes, please turn it off
2) Is postgres allocating sparse files?  If yes, please have it fully
allocate the file instead.
3) Is postgres using preallocation (fallocate)?  If yes, please have it
fully allocate the file instead

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
