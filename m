From: Mark Brown <ntdeveloper2002@yahoo.com>
Subject: Filesystem testing
Date: Wed, 5 Feb 2014 15:20:27 -0800 (PST)
Message-ID: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com>
Reply-To: Mark Brown <ntdeveloper2002@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:29385 "EHLO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbaBEX0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 18:26:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,
What are the most common testing tools used for stress testing ext4(or =
any file system..), and making sure the data (and metadata) that was wr=
itten is correctly read back, operations that were done(whether usual R=
/W, but also others like truncate, stat,link, f* operations etc) did no=
t cause problems or corruptions, do fscks if needed etc?

Also, are there tools that can cause aborts underneath the file system,=
 basically something in the mid layer that randomly drops IOs or someth=
ing along those lines?

I am looking for tests which can fully stress the system exercising the=
 file system and also check for corruption.=A0

As an aside, I looked at xfstests, from what I could gather, it was sta=
rted only for xfs, but there is ongoing work to make it work with ext4(=
and thus other posix FS?). If someone can point me to the documentation=
 for xfstests and what it does, that would help. I could not find much.

Thanks in advance.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
