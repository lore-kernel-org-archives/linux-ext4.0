From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 7 Dec 2016 10:58:25 -0700
Message-ID: <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca> <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8F507A9E-20E3-4661-AD0C-081906AED933"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Renaud Mariana <rmariana@online.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:32822 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753437AbcLGR7G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2016 12:59:06 -0500
Received: by mail-io0-f174.google.com with SMTP id j65so724463836iof.0
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2016 09:59:06 -0800 (PST)
In-Reply-To: <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8F507A9E-20E3-4661-AD0C-081906AED933
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> wrote:
> 
> Here are my answers, hope it will help solve this issue, thanks.
> 
> Recap:
> dpkg kibana on ext4 over a nbd device takes 10 minutes
> with xfs it's only 30s.
> with ext4 no extends only 30s.
> 
> 
> kernels :
> 4.5.7 has this issue as older kernel like 4.4.34
> The issue is also when nbd client & server run on same host
> 
> 
> How small are the files?
> here is the histogram of file sizes : http://pasteboard.co/6HC3nKyk2.png
> We can see 5000 files around 512 Bytes.

Definitely there is no value to use fallocate for 512-byte files, or any
of the files that can be written in a single write() syscall.  I'd expect
any reasonable tool to be using a write buffer of at least 2-4MB these
days to get good performance, so writes below the buffer size shouldn't
use fallocate() at all.

> dpkg using fallocate() ?
> Yes, there are 16044 calls by the same process
> what are these uninitialized extents ?

Uninitialized extents are preallocated ranges of a file on disk that will
read back as zero, but are not necessarily zero-filled at allocation time.
For large files that are written randomly (or written slowly and may have
contention from other writers) fallocate() + uninitialized extents will
preallocate the space for the file so that it is (largely) contiguous on
disk and overwrites will not result in random block allocation.

Cheers, Andreas






--Apple-Mail=_8F507A9E-20E3-4661-AD0C-081906AED933
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEhNwnKl2rkXzB/gAQiSag//cpSISc832Quc0KO+K1jt4i61NAFPfpfq
7X4tS6ucrkMUK/YjExLLE3dStbGgdFtSg5IQeqfsF+ChwUfnI+W4Q0pEaLRsMFvR
2uZf2b6VC+AktEGWdrZQ8FpMragg1e+APa4vos9cKVMAKgiTEpY98ce7DPW7nklg
T/2jCKNqJoHbnL8DNjY32jU0Jcv6iocuMZ44Wzgkwn0YrumZNwZClGMYFNBSmRoY
/C3P+ygHz9N4GLZRNBbqQ9HQzp7SYq5lSBdDYfPfhMKPgcDoaAr+HeYDVIlMv7A1
senS53jAavByvmyzZ+4grySYTRUhNTv4plqT7kDZdiO7zKPF+wA4xPl2auHoZMDr
dVU/TH3yiNcYpJHSqusYOrwr1S3UR8GM+ekagsE0tBvKcQP99cCFq+tczOOL30OI
kXqsrP2lwVAL5i2Ugk0Bgk4K/eiHT01ibRdzre4QLmpl379dBP/39lSVbn8NqLZa
hunc6fJXZJMqAlfPI0EIhe+JPO2jsoVTFLs639tHrE12JZ00tmuzu+JZIAQqGDI9
w2+7hhcPrbPl0PfeUFpQUtkYhATjPIldev8qXZK1vPjYiHvYZs8wsdb90Uc2JdWv
6xOErDo7+//IJz/nOmonRbD1Z6rme0iQqmVQl2hzBkDQlsuFRzjVvIBzGTzcPm6P
9e0HCiRC1bk=
=u/pr
-----END PGP SIGNATURE-----

--Apple-Mail=_8F507A9E-20E3-4661-AD0C-081906AED933--
