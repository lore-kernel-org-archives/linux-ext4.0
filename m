From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: EXT4 data block allocation alignment
Date: Wed, 11 Jun 2014 11:58:17 -0600
Message-ID: <4B4CADE4-6780-439B-AD5E-4DDCA9EB4EA5@dilger.ca>
References: <CAKTMprNG5GzBQ1wmPhvCWzr3OKcsj8HCQ4f-mez_bSvw5D9f4A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4005BB95-2D58-4F80-9010-3B8E3287F398"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Teng-Feng Yang <shinrairis@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60479 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaFKR6L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2014 13:58:11 -0400
Received: by mail-pb0-f44.google.com with SMTP id rq2so60320pbb.31
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 10:58:10 -0700 (PDT)
In-Reply-To: <CAKTMprNG5GzBQ1wmPhvCWzr3OKcsj8HCQ4f-mez_bSvw5D9f4A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4005BB95-2D58-4F80-9010-3B8E3287F398
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


On Jun 11, 2014, at 5:44 AM, Teng-Feng Yang <shinrairis@gmail.com> wrote:
> Recently I have been working on a small project which requires data
> blocks of each file to be aligned to 512KB/1MB boundary for
> performance reason. As far as I know, this can be accomplished by
> setting the stripe unit on XFS or enabling the "bigalloc" feature on
> EXT4. However, the "bigalloc" feature has not yet been stated to be
> stable in the latest release. So, this makes me wondering if I can
> achieve this block allocation alignment by setting the stride-size on
> EXT4. The document of mke2fs only says that this value may be used by
> the block allocator, so I am not quite sure what it can offer for me
> in this case.

In fact, 1MB alignment is already the default behaviour for ext4
extent-mapped allocations, though it isn't enforced for small files.
It is possible to specify the alignment with "-E stripe_width={blocks}"
(blocks=256 for 1MB and =128 for 512KB, assuming 4KB blocksize).

It might be possible to implement this alignment as required instead
of optional for data blocks, but that would need a change to the code.
It would still be more space efficient than bigalloc, since bigalloc
will allocate a full 512KB for each metadata block or directory.

Cheers, Andreas






--Apple-Mail=_4005BB95-2D58-4F80-9010-3B8E3287F398
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU5iYuXKl2rkXzB/gAQLaOA//SHkQHuQkjXpxQnnA0zmytNJznbISlejp
ymi9R5+uS+NtmgXob0fFQTiAY6xv4lfhnLMbfKPGQzTtAF5NX7WCC9ZtpZTa3kRO
chx0kcFaNmjaZ6VoPcn3OH4BBSNT6tef6WIFTeEK4NtNx1kpISrDv13SFFvUN//Y
LGHOqScYpCwHnD7hQiC18wkds4xBLcVT13lKFm8P7Rch7VT+tjg6eKQliEe26TZY
TpzT6mlTMUKbAt62ENn7QMgDQLUs8NzjFzVGe32R985z2kU5jttdTNBDFE+f26ur
dzOlxWvV/wCVKJ27SdCkE045NUXBAgj6S6CkeQv8MRAEsqW4BzjwfH7c+GBvWXzC
55G/BFTHgojWwGa8hJmvSvPBM7TnKES3xUnm2HGnd/rrLfimIwHVruorThvALNI/
GhN9fctVuBjH0euWUsR/sodj5qHIOp+41Vnn7J0QcPGDu1N3okxOx+Ep7lvdARzH
N3thq5iUfkHR4mTcoABo4w/cqUMwuxBXhUKMaVM2Ox3PvmfMTgkkxmdBKu3X94Yq
/g5RrtPAlBMvcPQ26nNMHPklqZTi8hq4IbHsiVPQAmgkJ3qD6QCTe8kjc0SPLuk7
CExhXfPTocCaglfdA/3VijSP0j5YDigoSrAtdeRq7FygY9vw00Q3Kpe4HEjdOjVo
yDovI+lYxyQ=
=uDeV
-----END PGP SIGNATURE-----

--Apple-Mail=_4005BB95-2D58-4F80-9010-3B8E3287F398--
