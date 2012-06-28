From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_fallocate
Date: Thu, 28 Jun 2012 11:23:14 -0400
Message-ID: <4FEC76E2.1010006@redhat.com>
References: <4FE8086F.4070506@zoho.com> <13363B8E-7411-4AA3-8835-F9DEF67B2ABE@dilger.ca> <4FEC744F.6010901@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab2F1PXQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2012 11:23:16 -0400
In-Reply-To: <4FEC744F.6010901@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/28/12 11:12 AM, Phillip Susi wrote:
> On 6/25/2012 3:33 AM, Andreas Dilger wrote:
>> There was a recent patch series "ext4: add an io-tree to track
>> block allocation" that may improve the performance for your case of
>> overwrite of uninitialized files, but it hasn't landed yet.
> 
> I'm confused.  Why is writing to uninitialized extents slow, and why
> would this help?  If you have an uninitialized extent, then the blocks
> are already allocated, just flagged as containing uninitialized data.
>  Writing to them should be no different than writing to initialized
> extents, save for the step of clearing the uninitialized flag.

The other piece is that large uninitialized extents get split into
up to 3 extents if you write into the middle of them so there are
potentially a lot more metadata updates flying around.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJP7HbhAAoJECCuFpLhPd7g8BUQAKlVb3EXtDNbziXkmKdkbDWo
wf/l4CMol/oxnLbKbvVkRQmRKfhdAsX5qQgmRqJvT3dPFzA7jSZqKDt3BV06fBSn
lJqWwdtHwjodeTj2UcoLZm2+8tL3d4AtJw42IntVasRtZRrUGZ5mFi1HMjm8vmK8
xSkmC/YbFtj222WiIpjLyu0XBZtSX9uMP4NZoThmA3MwuEcFr6AVqgi0WW3GVZP+
2L1ylMJDs6OykE+/Tv4AkFZ7XLtE946ytpqI6rLJvbItWdw1OqWhL6XWnOnGUgYG
B4IM5klovqIFOCPkHj0DPLm/RWjhv/+DJMkqEHAJANu4kEyS4O08Acqy/sAf1y4U
0OWCIW6fUHzV/38aMuQlLZeN+enaVmSCMh1kBWlGEeElZ/pRxClpiO+1Rk1Z7x1z
f1H+J3NV+wwGa3xiG6XO9biIMo10qdQMy93KLkeh6ndE3SYgvaAxC0AatrTZJS9Q
oRiKJLl3uTv1j0h+W+CBsRRmPzf/ad1kUKKPfT0recxy7ggO6X+6fkgsgRo3LRfN
53uAQWELJJu1opM9PsBuvX4uUvKLgbPXmky3JDS+Q3p18I4DfiBiIEPKbkZAkeD/
py0oxuqs0MGTRd9FCCqNODG2AJ7VWnY29hUOaCgWeFT5eG/r9tECJI6l62z4GeBx
b5+TFFsdJ/zJVBdjBuIT
=WcmZ
-----END PGP SIGNATURE-----
