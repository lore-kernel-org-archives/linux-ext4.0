From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 7 Dec 2016 11:16:42 -0700
Message-ID: <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca> <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net> <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_37B44C29-2EC6-466A-8AAC-D81F6C33D98C"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        debian-dpkg@lists.debian.org
To: Renaud Mariana <rmariana@online.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34867 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbcLGSQu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2016 13:16:50 -0500
Received: by mail-io0-f173.google.com with SMTP id a124so725788006ioe.2
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2016 10:16:49 -0800 (PST)
In-Reply-To: <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_37B44C29-2EC6-466A-8AAC-D81F6C33D98C
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Add debian-dpkg mailing list to CC.

On Dec 7, 2016, at 10:58 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> 
> On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> wrote:
>> 
>> Here are my answers, hope it will help solve this issue, thanks.
>> 
>> Recap:
>> dpkg kibana on ext4 over a nbd device takes 10 minutes
>> with xfs it's only 30s.
>> with ext4 no extends only 30s.
>> 
>> 
>> kernels :
>> 4.5.7 has this issue as older kernel like 4.4.34
>> The issue is also when nbd client & server run on same host
>> 
>> 
>> How small are the files?
>> here is the histogram of file sizes : http://pasteboard.co/6HC3nKyk2.png
>> We can see 5000 files around 512 Bytes.
> 
> Definitely there is no value to use fallocate for 512-byte files, or any
> of the files that can be written in a single write() syscall.  I'd expect
> any reasonable tool to be using a write buffer of at least 2-4MB these
> days to get good performance, so writes below the buffer size shouldn't
> use fallocate() at all.
> 
>> dpkg using fallocate() ?
>> Yes, there are 16044 calls by the same process
>> what are these uninitialized extents ?
> 
> Uninitialized extents are preallocated ranges of a file on disk that will
> read back as zero, but are not necessarily zero-filled at allocation time.
> For large files that are written randomly (or written slowly and may have
> contention from other writers) fallocate() + uninitialized extents will
> preallocate the space for the file so that it is (largely) contiguous on
> disk and overwrites will not result in random block allocation.


Cheers, Andreas






--Apple-Mail=_37B44C29-2EC6-466A-8AAC-D81F6C33D98C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEhSC3Kl2rkXzB/gAQjKIQ/+KXcg5X1kfUa8SJDMmAZwZRexT+xwZ9a8
20wEcH8618gvMY+6OqwZ0fFFwY6r1bIuW2ecZE0L5ikMvarYQzLoTeIsWlNX7a8U
RaEj6xHQ6SLRU60J5x3q8wU8Q/ScGFYtqz41RZu1itvbl85QMW/uWix0zhu51Opz
XH1Hh1T6AAr6Bdzb572eHYaK1ClAda8MNBnfc4xoha0yBSkEwfGIcGbx8Ixi5335
LPdN1xcwYc12+3v/Le2EvuEVQVl5eAL/0mQpqGHhAtfYywqAxSeLn2wjJ5OCuVAh
E0/zP/HH3jceY2CIg7WzB1g62yS4snmU/GViPhN4H2we7hMHPOrLVZHx0y9xH7tI
OZCWzQl2DXRIXYobkj37mCGoTM/lfiFiVgkLkVg3BeWVtHKdcQsJn2CekXGR6XIW
E2/qKuT/TzXeBMosWgV6XeCzU3o2tHMdnowsm75keXQEMIhvIj7JmS+8FTk0LH6J
2po+PmJ1Tx/cG9IvGmKngE0hAXRZ0cYNFTbnjSxpvhxDOnyhRrZHSJB/Z4zFTDUF
R8KFdHVY3WKEIccFxSW3DN9lv8GQtCZVBXFQejdPUNSWucxtb74rs1EeB87t4NO0
nl49cAsbujwNqXxFkN4oOtABaFsb8iaEyrSsjJsoDzjaK0PUgWZdaa7DFvHY4sbT
mQrn7bZHqgw=
=sqxQ
-----END PGP SIGNATURE-----

--Apple-Mail=_37B44C29-2EC6-466A-8AAC-D81F6C33D98C--
