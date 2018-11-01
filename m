Return-Path: <SRS0=aByE=NM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:33107 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbeKAJms (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2018 05:42:48 -0400
Received: by mail-it1-f196.google.com with SMTP id p11-v6so912416itf.0
        for <linux-ext4@vger.kernel.org>; Wed, 31 Oct 2018 17:42:12 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <0C3DF51C-F627-47F7-879B-0A0D5BC143C0@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6DAA99BE-CD7D-493C-85AD-DD18080505DA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 11/11] ext4: access to uninitialized bh fields in
 ext4_xattr_set_handle()
Date: Wed, 31 Oct 2018 18:42:01 -0600
In-Reply-To: <0db97e14-c87d-9507-4c87-875835b64212@virtuozzo.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>
To: Vasily Averin <vvs@virtuozzo.com>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <b8523c3a-0eb2-3aeb-fdf9-2e9d6d320d5c@virtuozzo.com>
 <48BA929C-9BF7-4092-BDD3-BECB64AF0599@dilger.ca>
 <0db97e14-c87d-9507-4c87-875835b64212@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6DAA99BE-CD7D-493C-85AD-DD18080505DA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 30, 2018, at 9:39 PM, Vasily Averin <vvs@virtuozzo.com> wrote:
> 
> On 10/31/2018 04:30 AM, Andreas Dilger wrote:
>> Could you please explain your statement below that on-stack
>> initialization does not zero unspecified fields?  According
>> to documents I found, for example:
>> 
>> https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html
>> 
>> they *are* initialized to zero.
> 
> I did not know it,
> I re-checked it in generated assembler code and found that you
> are right and I was wrong.
> 
> Please drop this patch,
> should I resend of rest of this patch set once again?

I don't think it is necessary to resend the whole patch series.
Ted should notice these emails on this patch and not apply it.

Cheers, Andreas






--Apple-Mail=_6DAA99BE-CD7D-493C-85AD-DD18080505DA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvaS9kACgkQcqXauRfM
H+APEQ/+LKwBcyDcl5jacJue16RzP2SkekzEfNoBT7Im5yphpPaqVHj2mnrMkeKZ
SZ47lyRwtLTSahMGOK3jur1AIBg4pcdcBZzM8ydtIXnqs9Yqq3oCGQX1F0oz2aGQ
FlLKwNRphxhHlv2GfTpKs0eCkhZXlgWiLCfTZW++w/Xi7mypDYenQFLaTaZfVIgC
5z45X0KDaBy3oJWKT61EVAMlGVDJzD5oaFXUJyloi8iMgSGTV/Hlzrh+U7mw75nE
ENfmSqMb5CHBaFVkFhlNUCg8VUvJJr1X/kR4UXdsN48xlnDkKDTNwXMVyat4NOCH
6PX9cTAzRnngbjSxuvOvMy3/Ybov5K1mPWSr3FeKJFbXf0E2krMp8TjxOUGglsH5
F9Eefhr+33zufHYnkO3NMiCBXqe+Wyoaw7SuoRZGvaRJzHlEDKjgT/xOBhs/eWWE
iM/02LkXL2DGEmTS6WdW/BUMyNcCQWOWcZ11SsE04K1SpaKFhCWEr+dEMF+QDrYH
h9phvwVGwCczEHDdMaisj2/t81nFeqiYBimSaYGIMo8Qvoe6Y6ozadlJw3iShNmP
W+g2BOpii2Fl2KQq5WR+Cwewd9b+RpAsYELYqxiGtJL7Rw/zzCbsy9GMbRxO7hkU
eClUvYutAekvi7CutkHIu0ngeHFAK/ti+zbeabJNlokHZUXkwnE=
=aigz
-----END PGP SIGNATURE-----

--Apple-Mail=_6DAA99BE-CD7D-493C-85AD-DD18080505DA--
