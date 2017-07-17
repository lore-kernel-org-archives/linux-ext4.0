From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Collecting aged Ext4 profiles
Date: Mon, 17 Jul 2017 14:08:47 -0600
Message-ID: <5BCA327F-3BE1-43E0-802B-1656568FD7D2@dilger.ca>
References: <6F8D59B2-0630-4405-BC85-D634B122F3C8@cs.cmu.edu>
 <D52E9B43-C169-4C71-BFDA-0100C75FEDC1@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_7AD5B62A-00F5-46FC-BB4E-7F76687FBAB0";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Saurabh Kadekodi <saukad@cs.cmu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34896 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdGQUIx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jul 2017 16:08:53 -0400
Received: by mail-io0-f171.google.com with SMTP id k71so2688369iod.2
        for <linux-ext4@vger.kernel.org>; Mon, 17 Jul 2017 13:08:52 -0700 (PDT)
In-Reply-To: <D52E9B43-C169-4C71-BFDA-0100C75FEDC1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7AD5B62A-00F5-46FC-BB4E-7F76687FBAB0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Jul 16, 2017, at 12:34 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Jul 15, 2017, at 18:14, Saurabh Kadekodi <saukad@cs.cmu.edu> wrote:
>=20
>> Hi,
>>=20
>> I am a PhD student studying file and storage systems and I am =
currently conducting research on local file system aging. My research =
aims at understanding realistic aging patterns and analyzing the effects =
of aging on file system data structures and its performance. For this =
purpose, I would like to capture characteristics of naturally aged file =
systems (i.e. not aged via synthetic workload generators).
>>=20
>> In order to facilitate this profile capture, I have written a shell / =
python based profiling tool (fsagestats - =
https://github.com/saurabhkadekodi/fsagestats)  that does a file system =
tree walk and captures different characteristics (file age, file size =
and directory depth) of files and directories and produces =
distributions. I do not care about file names or data within each file. =
It also runs e2freefrag in order to understand the level of free space =
fragmentation, e4defrag in order to capture the fragmentation score, and =
copies a large file (~ 2GB) and runs filefrag in order to understand the =
file fragmentation, all of which are directly correlated with the file =
system performance. It dumps the results in the results dir, which is to =
be specified when you run fsagestats. You can send me the aging profile =
by tarring up the results directory and sending it via email.
>>=20
>> Since I do not have access to Ext4 systems that see a lot of churn, I =
am reaching out to the Ext4 community in order to find volunteers =
willing to run my script and capture their Ext4 aging profile. Please =
feel free to modify the script as per your installation or as you see =
fit. Since fsagestats collects no private information, I eventually =
intend to host these profiles publicly (unless explicitly requested not =
to) to aid other researchers / enthusiasts.
>>=20
>> In case you have any questions on concerns, please let me know.
>>=20
>> Thanks,
>> Saurabh Kadekodi
>>=20
>> PS: cc=E2=80=99ing the response and / or the aging profile to =
saukad@cs.cmu.edu is greatly appreciated.
>=20
> How does your fsagestats tool compare to the existing fsstats tool =
(http://web.cs.dal.ca/~morven/CSCI3120/fsstats)?  If there isn't a =
significant difference between the two, it would be nice to stick with =
the existing tool to collect the filesystem information so that the body =
of data collected continues to grow.

Actually, a slightly better URL is https://github.com/adilger/fsstats =
which is a
proper Git repo and includes the original license.  The original project =
URL
http://www.pdsi-scidac.org/fsstats/ is no longer functional.  I also =
have a local
archive of results from that project if you are interested.

Cheers, Andreas






--Apple-Mail=_7AD5B62A-00F5-46FC-BB4E-7F76687FBAB0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZbRlQpIg59Q01vtYRAvkkAKCn+j2ksVF1+jQmYoMO1XHhnclOkQCfYZFO
2uUTxMkf7o5gcReB1bQUptw=
=5ggy
-----END PGP SIGNATURE-----

--Apple-Mail=_7AD5B62A-00F5-46FC-BB4E-7F76687FBAB0--
