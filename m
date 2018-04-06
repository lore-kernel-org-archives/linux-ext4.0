From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Patch 0/4] RFC : Support for data gradation of a single file.
Date: Fri, 6 Apr 2018 15:31:39 -0600
Message-ID: <63F7D7EC-EDF0-49FC-BAFA-F49695F1263F@dilger.ca>
References: <CAExFE6n2npo8Uomk=bNYnC4CVL9aWQDMRdOeav0vAdce1prNMQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D614729B-5D1F-412C-BE0C-8F1581A6F671";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Bhattacharya, Suparna" <suparna.bhattacharya@hpe.com>,
        niloy ganguly <ganguly.niloy@gmail.com>,
        Madhumita Mallick <madhu.cse.ju@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Bharde, Madhumita" <madhumita.bharde@hpe.com>,
        Jens Axboe <axboe@kernel.dk>
To: Sayan Ghosh <sgdgp.2014@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAExFE6n2npo8Uomk=bNYnC4CVL9aWQDMRdOeav0vAdce1prNMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_D614729B-5D1F-412C-BE0C-8F1581A6F671
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Apr 6, 2018, at 5:41 AM, Sayan Ghosh <sgdgp.2014@gmail.com> wrote:
>=20
> Hi all,
>=20
> The following series of patches aim to store a file with a graded
> information. Consider a scenario of video indexing for learning
> programme where some of the portions of the video is annotated and
> important than other portions, hence to be accessed more often. We
> consider the similar scenario where we have a file along with a grade
> information that mentions which blocks are important and which are
> not. The grades we consider are binary with 1 denoting high grade.
> Now the file is stored in a LVM which comprises of different set of
> storage devices belong to different tiers (as ext4 doesn=E2=80=99t =
support
> spanning over multiple block driver), - one combination could be
> persistent memory and hard-disk. The target is to store the higher
> graded blocks in the higher performance tier and the lower graded
> blocks in the lower performance tier.
> Consider a C code where the grade of the file blocks are being set in
> the user space through extended attribute. The grade structure stores
> the span of different high graded segments in the file with starting
> high grade block numbers and the span length of the segments. We
> assume grade of rest of the blocks as 0 (low).

There was a considerable amount of work and discussion on implementing
Stream IDs for the block layer.  This would annotate writes from =
userspace
and allow the underlying storage (filesystem and block layer) to use the
stream ID for block allocation.  See the following for more details:

    https://lwn.net/Articles/717755/
    https://lwn.net/Articles/726477/
    =
http://lists.infradead.org/pipermail/linux-nvme/2017-June/011322.html

In the absence of other information, the Stream ID would just mean =
"group
allocations with the same ID together". After some discussion, it looks
like the latest patch has generic "lifetime" hints rather than "stream =
IDs",
but the end result is largely the same.

It would make sense for you to spend time testing and fixing that patch
series instead of trying to introduce a new interface.  IMHO, there is
no need to make these hints persistent on disk, since their state could
be inferred by the allocation placement directly.

Cheers, Andreas






--Apple-Mail=_D614729B-5D1F-412C-BE0C-8F1581A6F671
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlrH5zsACgkQcqXauRfM
H+Dh3Q//ejF6WKrfHIVZZm4ex74dfgX3u5ztgvoHRHcvbbSqPwvnllnOn18LT3jE
dcelCkT+39YlBu0XTO/k32S+eDnKSSfxJunDGvWTqctbvR3Qo2ui7aSyZV5Qjnoi
bcUTilDVYETSzBDmUuwxzv94e7f+7BgsOmuMDr+F4Xnzmv0l82FeMoDFUnSIotzL
Jbur8rggs0TZYTaPc67wcf3RMdWjL3d9Bxo0UINSvr8U1WVuUbEJsGjLyBEJStB8
PNZjv9n5Px7gFuqqRHJ/hgkEF9OhweW5zR6wVIPgnMIQcebT07R/IiSi9Wz2DrUJ
WUVv1Vs/rFP3W901jum8JoC9CNtn8aJQNZMEx76xYZ8cIqHpSMDy97IFBxXmxgVa
aXcmnONKyaoSgNd4vopIyfcAED8/apLsyafgmJc0DJsXJdflBzD0MuCi8oy1AgPR
9391BoyCyUZcRurL7s6CAv1VJhu5OFRfGZzdznhpUef/A3tnvdwsP4EIE0fKsqyQ
Csct+Ynkp1h5rMesUaXu6U0YRDHH5+J2lqoZygVkvW7v9J6MynBaJXiji+sOvOM+
DpRNTZHBntw3Vq40DCRjyrrYmpApXMV6xc/gZYgf43/IvAg/snZNML+w0q/W+/3K
eTSb0x9sD6xYqsOh5zf3VgwrPKikfyabtsYUkW4RPqpC5OEzcfQ=
=fg0x
-----END PGP SIGNATURE-----

--Apple-Mail=_D614729B-5D1F-412C-BE0C-8F1581A6F671--
