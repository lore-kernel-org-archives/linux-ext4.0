From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] Increasing efficiency of full data journaling
Date: Fri, 07 Mar 2014 20:41:31 +0000
Message-ID: <bug-70121-13602-efgGC3A17O@https.bugzilla.kernel.org/>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59477 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaCGUle (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 15:41:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22FC820328
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 20:41:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A92E52034C
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 20:41:31 +0000 (UTC)
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

--- Comment #9 from Phillip Susi <psusi@ubuntu.com> ---
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

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
