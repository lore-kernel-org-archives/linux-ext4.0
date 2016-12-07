From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 7 Dec 2016 11:12:32 -0700
Message-ID: <452CC006-0197-45C0-BA00-CDA0F8132965@dilger.ca>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca> <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net> <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_1B5619F0-9CCA-4FEC-B68B-54668EDCB394"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Renaud Mariana <rmariana@online.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35518 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbcLGSMi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2016 13:12:38 -0500
Received: by mail-io0-f172.google.com with SMTP id a124so725566493ioe.2
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2016 10:12:37 -0800 (PST)
In-Reply-To: <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1B5619F0-9CCA-4FEC-B68B-54668EDCB394
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

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

It would probably be worthwhile to file a ticket in the Debian BTS:
https://bugs.debian.org/cgi-bin/pkgreport.cgi?dist=unstable;package=dpkg

with your information, so that there is something to submit a patch against.

Cheers, Andreas






--Apple-Mail=_1B5619F0-9CCA-4FEC-B68B-54668EDCB394
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEhREXKl2rkXzB/gAQifKBAAm/DOImco8TDbj3WQ786Ml25QL/PwO1qI
GIPC+mJP2V5KYShHWFwDOTKZZA6tRXCoKOiJU2iYW6gn3jA4iz+GPq380CO10nt3
U7XuKlHeze3j1BnnL4vUuMMm/Q6DGfem3JMCvFcGNmqdWyK+msby09dbJaNCBIBk
3HloEw6OyDwCcVQGWR2OF0Z1JaSqAKRMkYVz+TIpK9+xYAMV04+i+1xeyGMgYjnT
yYnS8uFQL1zNFOjBAYC61c7oy62RMWJRimFtEVJUGysZO1rtQ0MU+jCxhdeEO+m+
I2XDhZtHCf9bFWZ21kWprG7qwvc+GskKMyJxSe/0ugmKWXMtvvp8m85shtwJQD2I
zhMnl02J/epTjfrfA7Cure18iAE0Uv3ItI7V6Bn20Qm5meid/23l7qG23jE9Q77h
RsyEnHfbjWvVYN5DeAgCcfBoHGbdHNWRpmI8ihijyeR97jPXswH+xGUSnWoum+VI
oBikVmztXjfYS6LVhM3aMxeacbIg9RM7pucYD1NocWyPponZqQOxnX16LBwvrrs1
6kg/KJwHeSRVjgD5BAmkC4fnM0Ux7IB2TfaAMnohSQrTa53TkDuLpYuJ/nCpKyN2
nQBT5/WljDzNtWnTJMm1V2xD8YnRqdHBm8yIQpt7OdSbR59E60m8zLnl1jASySNy
A+9QbxKGQ+Q=
=Z07v
-----END PGP SIGNATURE-----

--Apple-Mail=_1B5619F0-9CCA-4FEC-B68B-54668EDCB394--
