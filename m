From: Phillip Susi <psusi@ubuntu.com>
Subject: acl option silently ignored?
Date: Thu, 06 Feb 2014 09:24:41 -0500
Message-ID: <52F39B29.4030303@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49746 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBFOYn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Feb 2014 09:24:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I came across a debian bug report and confirmed that when you remount
- -o acl, dmesg shows ext4 acknowledging the remount with the acl
option, but /proc/mounts does not show the acl option.  Is this a
kernel bug or is it intentional?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS85spAAoJEI5FoCIzSKrwBw4IAKX9QSn4P6F8k1q8YqFzNvGD
F4nuE4y54N0oGWmb1wXn0T0v2c0dWomJSN8QgqMUgfTWPy4vN9KTLJFK6xCZNP21
5PtAVe4SGKfXTLWWGAYpZAf50TH7Qxigos3Wcgfzi6YeZ8vu4U8I7eBMFBPe5uO7
XoYQYUKEZWTpO1RxxeQWEt2OBVnjAMssmE+Hi05t5/Q1kbGQCCIZe2QlGkLLspya
PIk3TViA6ZFtm7em6nUnNFTg+LRigyfF3+X51uUx+RGK8ljDhbWO1TGC5XUFigyX
aWrF6BGuT09I06QVeIBzpp5hiR353vkOV3ILcDfmQmUmsHWEsnV9+NKW/x3LusY=
=HSoQ
-----END PGP SIGNATURE-----
