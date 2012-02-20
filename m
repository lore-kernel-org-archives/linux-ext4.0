From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 16 TB filesystem limit on 32bit machine
Date: Mon, 20 Feb 2012 16:50:49 -0600
Message-ID: <4F42CE49.80209@redhat.com>
References: <CAJZuRVZ5BC+oJA_4HqdwnJvME8XuDeCWWt_6pugOuBFjp8v_SQ@mail.gmail.com> <4F4279F1.8060805@redhat.com> <4F42B86B.60706@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Rabeeh Khoury <rabeeh3000@gmail.com>, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2BTWux (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 17:50:53 -0500
In-Reply-To: <4F42B86B.60706@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/20/12 3:17 PM, Phillip Susi wrote:
> On 2/20/2012 11:50 AM, Eric Sandeen wrote:
>> fs metadata is mapped into an address space, IIRC, so can't be
>> addressed past 2^32 pages.  Also, mkfs can't do buffered IO to the
>> device past 16T (it is writing to a device _file_) and ditto for
>> e2fsck.
> 
> But the file is only used for open(), after that the IO is handled by
> the correct device driver, which handles 64 bit offsets ( when you
> have CONFIG_LBDAF on ).  So if you can change the page cache index
> size ( and it doesn't blow up ) this should work fine.

Oh, sure - if you change pgoff_t to 64 bits, but until then, you
can't even mkfs.ext4 a device larger than 16T; there is nowhere
for that buffered IO to go in the page cache, right?

(You could mkfs.ext4 a 16T partition on a 40T lun today, thanks
to LBDAF, but not a 17T without changing pgoff_t et al)

And "if you change the page cache index size" that's a big leap
of faith, today.  Might be interesting work to do, but I'd bet
it's a real chunk of work.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPQs5IAAoJECCuFpLhPd7gFGcP/REp9fxQJEXP/JoV8ixcdPmi
Grs15shrEuaJDTnz120wOVS+HSyYU7EczdC1uL6dHFtxqSm/gpdRka5zabz2L46l
RWcPjEofLjR45PWJaGzkWQrmrL9tyJdgP83idUUPl9AlGLbK4jgpzgs9OB0tf639
7lf/a711cZT1G7fLg02ZHb88TGE5BltEQHtX1nk1k4srLgjFKRCi5Am+auXgu1ta
W0Q3a+oxPlkOiVcr499xmInsAhPHBuErtd7B/S7ViP7Cz+Bhbv25xcM77jwRHmtp
9kwkt2ntQ4v9dccmlqpIMElqQJQGKU1li2ySzmJTUbS8jzmBXG/kXtUEr1y50tNc
tm6kIPkMX0RkXRIOfri2jq4LBV0Nl1uGIqUEbUvtJDMh9s4tBtlKV0ZWJi9foIaW
OqMAiEhvgb5tpMZG9gjfCSxnMelUAMC9LrygRG04O26Q9vQMEDD57Ee77MOTOZId
1g01fxZzcmd+UXlfDWmHtgSjotSMyp6pV0lWro82qe1pKo7HwwCjIA2KeHu9owTa
zmzvzbopd0OoUUmXzqAx2kBdxhhNqoqB2AQXfDf8tmyckA8YY4KMgJhKjFSfMc54
ZDzvWuJI11WoBsia9LlAbcFq0Dchd64Mq6As/By9N6QBWV0LdhkikSTFGTzKL4D2
FrAh6QhIiRhkaGiEI5XG
=2bla
-----END PGP SIGNATURE-----
