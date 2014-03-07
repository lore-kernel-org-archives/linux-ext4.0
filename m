From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [Bug 70121] Increasing efficiency of full data journaling
Date: Fri, 07 Mar 2014 15:41:27 -0500
Message-ID: <531A2EF7.5010005@ubuntu.com>
References: <bug-70121-13602@https.bugzilla.kernel.org/> <bug-70121-13602-Vy8eJ3NxWe@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40192 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCGUl2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2014 15:41:28 -0500
In-Reply-To: <bug-70121-13602-Vy8eJ3NxWe@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/6/2014 12:28 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
>> It does no such thing.
> 
> What does it not?

write("foo");
              <-- crash
write("bar");

Your file now has "foo" and not "bar".  The fact that "foo" hit the
journal first, and may or may not have hit the final location before
the crash doesn't change the fact that you crashed between the two
write calls, so "bar" is certainly lost, and if "foo" did hit the
disk, then you have a partially written, and thus corrupt file.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTGi73AAoJEI5FoCIzSKrwQq8H/0+giACBP1uYn6fN97yEjGT+
movV5ITpmc6Aq11E2GSF7T60ehTV2Q27PYjxr4YF/fHUfkthBKyISgONwTpXiDUk
tYCpMKuAokC5zmhl2UlTwain+Y/By9UnH3DjbAkg7trnGiEcuT6AJXUZh7fYPPXq
AKnJNYT+LI8EzPLKRf4DbtL5mPmRsaGDa7zCZ5eVQgtyao1LmaFNTcaojUATpw/n
p4cwBHkcauQSs126Z0XryiWXrOpBoYRCwFF42DIlAOd5tSnGyhbE75ul83m5lCC4
BlRrZ6+057RPiYFpmbgTsatatSZBbuGvEwuTICHDJiR8jqmucjarKPg9/wocERA=
=PKiE
-----END PGP SIGNATURE-----
