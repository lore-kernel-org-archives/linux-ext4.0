From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 2/2] filefrag: count a contiguous extent when both logical
 and physical blocks are contiguous
Date: Tue, 19 Mar 2013 14:44:46 -0400
Message-ID: <5148B21E.1050708@ubuntu.com>
References: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com> <1362327978-30423-3-git-send-email-wenqing.lz@taobao.com> <20130313201611.GH5604@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:42921 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3CSSos (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 14:44:48 -0400
In-Reply-To: <20130313201611.GH5604@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/13/2013 4:16 PM, Theodore Ts'o wrote:
> If we want to optimize the time to copy said sparse file, and if
> we assume that by the time we are defragging said sparse file, we
> are done doing writes which will allocate new blocks, then having
> defrag optimize the file so that when the extents are sorted by
> logical block number, the physical block numbers are contiguous,
> then that's probably the best "figure of merit" to use.  And I'll
> note that right now that's what filefrag is reporting, and what I
> think e4defrag should be changed to use when deciding whether the
> donor file is "better" than the original file.

That's certainly exactly what I expect to get after defragging a file.

> But that's not necessarily the only way to measure extents, and
> the current e4defrag code is clearly of the opinion that if the
> file is using a contiguous region of blocks, even if the blocks
> were allocated "backwards", that there's no point defragging the
> file, since after all, if the file was written in such a random
> order with respect to logical block numbers, it will probably be
> read in a random order, so keeping the file blocks used contiguous
> to minimize free block fragmentation is the best thing to shoot
> for.

That seems wrong to me.  It shouldn't matter what condition the file
starts in; the end should always be a file with blocks allocated in
the proper order.  If there's no point in defragging a randomly
accessed file, then the user shouldn't bother running defrag on it,
and conversely, if they do, it should perform the task they requested.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRSLIeAAoJEJrBOlT6nu7526UH/RTFmZWDXgrzGUwbbBJ1IN6t
aylOR1Wg3SWKEp5Cs717iHCNPMosF31bHkHG+MbpoSvJpAfRPZ7svTDTbzfBZ17F
dLKLOAYx3KRBeX8TSYIC7e5E/qTg1C6wmiS1Rlab5boeRkmUL/kP7WPpCgKHpydZ
tgUtzO7npCWVxP3eG9NnOR9y9U0PHuS3B9Q5S2vhbeqpxQnEi4cphoSw1bOJVcCj
RkddmEUuj+usDl8kHwxlyoiRhcwMUY59UuTqEWqgDkntQL5DTdX//AfrUdW3PBmB
DKIC4dCaoivXoKarKRuLaHM04rldOvZdxNFFNnoKlnQMhh4i82RnEYSio26778c=
=0Iea
-----END PGP SIGNATURE-----
