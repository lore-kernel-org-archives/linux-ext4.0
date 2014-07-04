From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 13:17:37 -0600
Message-ID: <9BEA347C-2246-4746-95A4-0E00E0369816@dilger.ca>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain> <20140626203052.GA9449@xo-6d-61-c0.localdomain> <20140627024659.GF6826@thunk.org> <20140629202516.GA11430@amd.pavel.ucw.cz> <20140629210428.GD2162@thunk.org> <20140630064644.GA23079@amd.pavel.ucw.cz> <20140630134313.GA3753@thunk.org> <20140704102307.GA19252@amd.pavel.ucw.cz> <20140704121119.GB10514@thunk.org> <20140704172104.GA4877@xo-6d-61-c0.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3B90E0F6-895A-4D87-9B38-8B0585201B19"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52210 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaGDTRf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 15:17:35 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so2286902pdi.4
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jul 2014 12:17:35 -0700 (PDT)
In-Reply-To: <20140704172104.GA4877@xo-6d-61-c0.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3B90E0F6-895A-4D87-9B38-8B0585201B19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jul 4, 2014, at 11:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>> pavel@duo:~$ uname -a
>>> Linux duo 3.15.0-rc8+ #365 SMP Mon Jun 9 09:18:29 CEST 2014 i686
>>> GNU/Linux
>>> 
>>> EXT4-fs (sda3): error count: 11
>>> EXT4-fs (sda3): initial error at 1401714179: ext4_mb_generate_buddy:756
>>> EXT4-fs (sda3): last error at 1401714179: ext4_reserve_inode_write:4877
>>> 
>>> That sounds like media error to me?
>> 
>> If you search your system logs since the last fsck, you should find 11
>> instances of "EXT4-fs error" message, which means that there was some
>> file system inconsisntencies detected.  The first error was detected at:
>> 
>> % date -d @1401714179
>> Mon Jun  2 09:02:59 EDT 2014
> 
> Interesting. I always assumed 140... was block number.

Maybe it is worthwhile to improve this error message to be:

    EXT4-fs (sda3): initial error at time 1401714179: ...

Cheers, Andreas






--Apple-Mail=_3B90E0F6-895A-4D87-9B38-8B0585201B19
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU7b90XKl2rkXzB/gAQJrmw//UuhTASDFKt6qM1dKuqJU8AoCgETanx2V
+VmfQpwqFwEKEN56EZ9HIdYVQvpXu2z0EOC6I3lhH68bkYOlk+gufMyjt20vTAQV
o8JLOca3vhG/uZBEPBQaL/4o+++KPFveuFA9FH+HXr5opeF772ifU+ptdjibf6S+
G5HWvqCTyk6TT6Zoca7bkKkHO7Hrt45dsjpjx6r9+DMFeInem8Q7W3JMDtaIrIDX
nIepXo3ltkT9n90uAVoV5QShqPUnb8cwtiQQ/8f6sPWsC478/8wG19IUyBjaTJL9
2LeIiX9i0Qh/UYw3ji9oFm+RTycoSaXq3qPg6UN2FZ3GikekzhL8BVTqp5XLQT6k
LaNMbnpe0vvwp6ppZe8oXfrB51ODdBhczuW30E0Os2ueSJNMZDLtaL0UxrQiG4M4
zdSZRb5SIdTGUVTAyBXPhgSDcU4bzGY7j/1UMC/vC+SAsmsmwxR0bcq/qF9URVQC
2LBr6Z7Eq/mIm01Ztwb4evVFcVtxYu+SNXIXRZ2PlVSCmNvWrwnlVbWac6vsq3Af
6ENDG75B0Vvs+OUpma69YBir5uGJpSn137qoaNNzdOBzTrYtpqnVrICrUNn9oUGo
FF7juz2MBSwHx9mk4CGIkT2vU3OtdMFttD05jf12HhgqhJVISSW3rA23+Dfn7G1B
sqw231zz0FQ=
=hh54
-----END PGP SIGNATURE-----

--Apple-Mail=_3B90E0F6-895A-4D87-9B38-8B0585201B19--
