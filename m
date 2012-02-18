From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck and backup superblocks
Date: Fri, 17 Feb 2012 19:05:36 -0800
Message-ID: <4F3F1580.9020108@redhat.com>
References: <4F3F1439.5000407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab2BRDFg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 22:05:36 -0500
In-Reply-To: <4F3F1439.5000407@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/17/12 7:00 PM, Phillip Susi wrote:
> I have noticed that e2fsck always complains about block group descriptor checksums being invalid when run on a backup superblock, even when run again immediately after being told to fix them.  Is there some odd intentional behavior here I'm not aware of?

Check the list for:

"[PATCH] libext2fs: quiet spurious group checksum errors"

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPPxV/AAoJECCuFpLhPd7gul4P/3OOyVnLqAapkkApwJf1cRq0
SDNH/1d8cbldwLMizgAuE3omoJRbzgpy6jghOtq573e1IOIskbQFDxG8HBSg6GGn
E1Yw8UcaCqKERRiemTESmC6Idtj6EAusZJWeTlC9XRx0Cbx8bGJenlU6eR/vpxH0
AvOPmgJhNMcRyMdsHLsvXXZNER5j9St1AEEVa2Wzpo2PGyJjVP8jDnJiuhvz2bK3
nv5u28WSuF5y8zzTs0j6DT40XQlpT/OVNflqUGelhxKHBB+sT2c0VvaVhVy63hw/
yuaIMmnwggJSs6p//9iOtKJhTSmR6qSGuuT65ajMgixy66efRLI0C0e5Y/U4stS4
cpT8m8+FGILhIe+Q+sJ2nOxC1JUvZW3AQvi0/gLZDCpzBid9RrmigfU/FTxs4MQB
CD9QDkmhz7A7rUvRulC4NSSXcgErMtwC5zAXG9MKiFAtvMBqYXWhWoKfxslaZXOU
5sOIvoB+TOwlWL2StQgwnJjJMCZ9/Eju2VhgEFbZxEgpInaFpk/FUm2k4hzQpHY9
M1ItllWFrR/XMXxozmN1/KmynOLdBEf4rW/BouC+ZCGZLeUOg8M+obJFNICFQEXq
VLSvUfIfsLaLb2ApBUyq75/mvIQIo5mCjRYqi1Ev7Rx8XrFWHfNR62Q/VwAVU6X+
vqDKt1dPO06sBPpzOdiP
=jdg1
-----END PGP SIGNATURE-----
