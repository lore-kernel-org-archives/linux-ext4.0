From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Richacl and ext4 vs. xfs
Date: Fri, 4 Nov 2016 16:48:05 -0600
Message-ID: <D3B85625-6E65-42A4-9935-17D5C9D65414@dilger.ca>
References: <CAH2r5msxM2spe2vH-mvrL-8MbYaaiAaQFU=Jhy_53NCLb079xQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_75FE99F5-FF3B-414D-A9B1-90E1A0EF8D7E"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38213 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbcKDWsK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2016 18:48:10 -0400
Received: by mail-it0-f51.google.com with SMTP id q124so12449038itd.1
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2016 15:48:09 -0700 (PDT)
In-Reply-To: <CAH2r5msxM2spe2vH-mvrL-8MbYaaiAaQFU=Jhy_53NCLb079xQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_75FE99F5-FF3B-414D-A9B1-90E1A0EF8D7E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

[added linux-ext4 to CC list]

On Nov 4, 2016, at 1:19 PM, Steve French <smfrench@gmail.com> wrote:
> 
> Andreas,
> I had been working on getting some VMs together to experiment with a
> few different Richacl configurations and it looks like the e2fsprogs
> git hub repo with richacl enhanced ext4 utilities may need to be
> updated or have an incompatibility with current kernels (See e2fsprogs
> github link at http://www.bestbits.at/richacl/ ).  XFS worked ok.
> 
> Fedora 24 Workstation, created two extra disks
> /dev/sdb for xfs
> /dev/sdc for ext4
> 
> Built and installed Andreas's 4.9.0-rc1 based kernel richacl branch
> and the other repos (xfsprogs, richacl etc.).    Had no problem
> formatting and using /dev/sdb1 as xfs, but once I installed e2fsprogs
> from Andreas's tree I couldn't boot the system (removed e2fsprogs and
> the ext4 partition and booted fine).  With Andreas's e2fsprogs I
> couldn't boot 4.9.0-rc1

What version of e2fsprogs is (the other) Andreas' tree based on?  The
newer e2fsprogs-1.43 has support for metadata checksums, but this should
be off by default in the released version.  The testing version had it
enabled by default.

With the working e2fsprogs, you could run:

 dumpe2fs -h /dev/sdb1 | grep -i feature

and see what features are enabled (in particular metadata_csum, and maybe
if the RichACL has its own feature flag)?

Cheers, Andreas






--Apple-Mail=_75FE99F5-FF3B-414D-A9B1-90E1A0EF8D7E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWB0QJXKl2rkXzB/gAQhY6Q//WsFh3qtXviXcWghVesgRgXxedHMdzEK+
qV9yS/Qf0tz8cYK3jRanwKetwYMUwGuRgmW8OiGL9AmrS09XHuNu57ZB5VNt4l1O
rrPumeJZ7iut+l5hZrPSUJw5InxxDrKdJvdklv5hQYwaumM0IprjIPctEn+cIi3L
T4nwVUfrLELH9BZtJhoOIMDjQ/hfc1NuR+Upg5FHLSR3ZVJKB7d37AOXa5pC6l+T
DJvmCV+hShbFiImAYG1sReUU/rTHkuz22QeKfYCqAqT8JtCrgl7/dRoSWB35m9ou
SFyOPFSuYIlyd8CguFtUzOCVWTSIHIXL6zjT/yKCvWxy8xKDF2XK0Z9k/6kkkiV/
DcZb1V3R5a1CedGCPjuC2Wpc43cXSWMQPlI+EpaoO+HASCoJVxPBaAixQ+dGHAbo
rexBh2JT/A9jhmgWOkYnjmK7hFrFVxaFyQHKwYSJCTF1T8O+kfeAgoXxxV6u/QT3
Ead6ZtHcQqH8xPvyi1y3Dkk1UDobMZCk4AD2PFp3dJb8CuZ56h/vUplLhVHeXdJn
TsjWJTwnsnqJTa/Kzk0UQbiARCXbszrFNno/J9E+dJBNYMLx4cHdc5Y+8XDpZafB
DmCB9hSwuMi9Z7UKJgrdimwI75y2XWObuc1FbwX3lHsDldi0FZXsXmshE9LmBPiD
JE5fuHIueTs=
=Cy85
-----END PGP SIGNATURE-----

--Apple-Mail=_75FE99F5-FF3B-414D-A9B1-90E1A0EF8D7E--
