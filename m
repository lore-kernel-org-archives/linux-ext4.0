From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Tue, 29 Jul 2014 16:55:27 -0400
Message-ID: <53D80A3F.5010807@ubuntu.com>
References: <d5c373beb24a9da86986ea43afe13594@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:56917 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaG2Uzu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2014 16:55:50 -0400
Received: by mail-yk0-f177.google.com with SMTP id 79so155532ykr.8
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2014 13:55:49 -0700 (PDT)
In-Reply-To: <d5c373beb24a9da86986ea43afe13594@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/19/2014 2:42 PM, Joseph D. Wagner wrote:
> Hello Theo.
> 
> I know you're working-for-free and have other things to do besides 
> work on my low priority problem.  However, I haven't heard from
> you. I just wanted to follow-up and make sure you got my
> attachment, not that anything fell through the cracks so-to-speak.

Just thought I'd suggest two things you might try:

1)  dump to /dev/null to make sure it is a read problem, and not a
problem writing the output file.

2)  You might try throwing e2defrag at the fs and see if that helps (
after a full backup of course ).  In the past I have seen significant
slowness when dumping due to my Maildir being fragmented all to hell.
 If you have any sets of large numbers of relatively small files, that
could be what you are seeing.  An e2defrag pass will completely clear
this up.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT2Ao/AAoJEI5FoCIzSKrwsOYH/R/k7GLCUEV59/didyUml6jC
MMZ3LlHBcFZQeWrZ8f0VlIJ46Kc3Cc7Xmc82GDFbhg6m+m2vkz48/78wj+CpQvn3
Rw/l6aJw9pC6c6riA6OzXdzYESJZI7njH+IEOJFJdtziUrBRcZ6W8UpIxkZ3DAWl
66CGz7UxfBYLme4RftIe1+dz6YKORNlwQ3Mnu16nocsggkA09gHbGqYQvMIpWGdj
3YiGhg95AT/KCpoyUoxkVq79tzay6c1JPn4mMSB2mOZpTx99oHd9WUk1yasIghk0
4yDOPtO2G1ZN0Mda3C3+cSs/FKoJu1U7ZDSklEGHlFy+cI1EZRi32+PLiMwfS+o=
=/SM9
-----END PGP SIGNATURE-----
