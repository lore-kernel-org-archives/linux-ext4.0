From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 settings in an embedded system
Date: Fri, 16 Nov 2012 09:44:36 -0600
Message-ID: <50A65F64.3020603@redhat.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com> <1352968933.2221.16.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>, linux-ext4@vger.kernel.org
To: dedekind1@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2KPPom (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2012 10:44:42 -0500
In-Reply-To: <1352968933.2221.16.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/15/12 2:42 AM, Artem Bityutskiy wrote:
> Hi, Fredrik,
> 
> On Wed, 2012-11-14 at 11:41 +0100, Ohlsson, Fredrik (GE Healthcare,
> consultant) wrote:
>> 2. Empty files, size 0.
> 
> Well, this is expected in some cases. If create a file, start appending
> data, and have a power cut, you may end up with zero-sized files.
> 
> This is a Linux feature - the data is cached in RAM until write-back
> happens or something like fsync() happens.
> 
> Ext4 has a feature that if you write to a file, then close it, ext4 will
> initiate write-back for you right away. It was added a couple of years
> ago to make it more user-friendly.
> 
> You really should investigate what are those files and what was
> happening to them just before the power cut. Zero-length files may be
> normal, in general.
> 
> However, strictly _all_ files you care about should be explicitly
> synced. This is just safer.
> 
> If you write serious medical software, you should take data integrity
> seriously in your apps.
> 
> I wrote this section for UBIFS users long time ago, and it is the same
> (modulo UBIFS-specific details) for other Linux file-systems, including
> ext4:
> 
> http://www.linux-mtd.infradead.org/doc/ubifs.html#L_writeback
> http://www.linux-mtd.infradead.org/doc/ubifs.html#L_sync_exceptions

Jeff Moyer also has a very good article on this:

http://lwn.net/Articles/457667/
 
>> Is ext4 a bad choice for an embedded system with I 1Gb IDE Flash Disk and Debian 2.6.32-5-686?  Should we change filesystem?
> 
> I do not know for sure, but I doubt there is serious power-cut testing
> regularly conducted for ext4, but people may correct me.

We do it here, though maybe not as regularly as we should.
I also periodically test journal replay, but not in a way that simulates
lost write caches or misbehaving hardware.  OTOH, those things are out
of our control in the real world (if users disable barriers, or if the
hardware lies to us).

But you absolutely should test YOUR system, audit YOUR software, and
YOUR configuration to be sure that it is behaving as you require.

It's absolutely possible to build & configure a system (software+hardware)
which correctly persists data even in the face of a power loss.
(or, in the case of a crash before data integrity syscalls are complete,
your software _knows_ that it was unable to persist the data).

- -Eric

> So if power-cut tolerance is important for you, you should conduct good
> power-cut tests.
> 
> And remember, the disk quality is very important for
> power-cut-tolerance. If you uses something like bad managed flash (bad
> SSD, eMMC), it may lose recently written data on power-cut. So testing
> is important.
> 
> Of course you should have barriers on as well.
> 
> We conducted some 3 years ago. Results were quite good for ext4 - in
> many cases it could recover without a need to run ckfs.ext4, sometimes
> it was not mountable, but ckfs.ext4 helped.
> 
> On the opposite, ext3 constantly required ckfs.ext3, and sometimes died
> so badly that even ckfs.ext3 could not recover it.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQpl9jAAoJECCuFpLhPd7go70P/AiAnzxaR7BhpBY+hMxEyA2O
YFmfvUsY8N51NdReE4NqO3ebu7BWIflTNHmzGaKWDQgXf2T6b1p6Cy2YVphBLsH3
Tfd5B1Aem8ZKVWq2pyuCjuQpNYOmlxibQPT4SWfzKukVO5sxgwiqL/e73awN6luF
U8zTCNnh1d8rOEEq/mSH1eeQSPdlY1h0lXegdBZ0CLkeI5/sTIFaEy8JiPBmKbrU
GsxsAyVEeko7aDL7Mh62RWFN953L/ZPkeVXWOoId8ANcZ+/Lrt/JEjkKIblkyHiK
FJTMSHeHTX8gg88HzFgWqkuB7aBlUB16Ppf5W2FFTUJOHtOcvIVlC5VGyYhYSe9L
DZZh/rxqjDpB8hFpvD6JPWLaTZ/UcIEBdYVlb+va5gfPjE+TBCRmUxRISLCg8opv
tsAQQo6kF818zGYQMtF3pwGkIHqP3DA+SRch/mh77ChTy0kGssgeZeKIoiz15cDJ
bgXR2hLHiuQ3/F3rqV5lCi8ioSPYvH2BmG1dhQdEAQAq48o25WjHOl7Rzpd38gEZ
BaAn0brYOlmW+oL09IKvBnSorZsmlPz5snwmZdxI7afp0ZbGJR1jx+7iqnl5sioG
4GtSwschP+tSnTSczQMlE6siGh3Alyq8vr7maIzsUODRyzdfsrx8koJs05hQEAIp
VzzJPsk6mv4J7E9VKhmH
=S0cP
-----END PGP SIGNATURE-----
