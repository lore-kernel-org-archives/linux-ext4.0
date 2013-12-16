From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/4] e2image: add offset switches
Date: Mon, 16 Dec 2013 11:30:06 -0500
Message-ID: <52AF2A8E.8030207@ubuntu.com>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com> <1381247792-22508-2-git-send-email-psusi@ubuntu.com> <20131216043228.GC28536@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62460 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3LPQaJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 11:30:09 -0500
In-Reply-To: <20131216043228.GC28536@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/15/2013 11:32 PM, Theodore Ts'o wrote:
> On Tue, Oct 08, 2013 at 11:56:29AM -0400, Phillip Susi wrote:
>> Add -o and -O switches to specify the offset where the source and
>> destination filesystems start.  This is useful if you have an
>> image of a partitioned disk or wish to create one.
>> 
>> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> 
> Specifying a dest_offset only makes sense in raw mode, no?

I think it makes sense in qcow2 mode, but it seems it doesn't work and
isn't trivial to fix, so I'll disable it for now.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSryqNAAoJEI5FoCIzSKrwJi0H/jA0887Dku5kMrpga3fTJCf+
rjGe93qHoqf6DOprj+2XI4cTJOY572729QrxKqbtlicY5F7lbB/9JKXn4VNcFJEk
6+1iQHh5mmFMP9g2hWxQPgfm93UAUYlC/pWyQvwTeUjKBp+EPYmoUtrDIZYpc79S
eFIsFt2TwduQ3zcwwLLOx2knQNyic9e3mwPF0NeIXbByfAW6hhPHLh1eg4zbTcJH
GYQqNyjk0vS0qmW+CBfAxyH4eYk6JgXtmg8c+8eePwlQLpbIoYW84cs6+yWbAu1y
1tVeqi2YTuYk+kU0t5DEj5sHoYzSXTZCukO8G/cThrhEMVnG1pwNRH8egjoyyYo=
=Ty8d
-----END PGP SIGNATURE-----
