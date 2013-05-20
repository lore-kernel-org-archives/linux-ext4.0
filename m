From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: BUG at fs/ext4/inode.c:1590!
Date: Mon, 20 May 2013 09:51:49 +0200
Message-ID: <5199D615.20106@gmx.de>
References: <5199514D.5090606@gmx.de> <20130519235504.GA8404@thunk.org> <51998A31.7060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61638 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3ETHvx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 03:51:53 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MP3Jh-1UbHwd1eUx-006P8H for
 <linux-ext4@vger.kernel.org>; Mon, 20 May 2013 09:51:52 +0200
In-Reply-To: <51998A31.7060200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/20/2013 04:28 AM, Eric Sandeen wrote:
> It's probably possible that it's memory corruption too.
>=20
>> > Can you replicate it?   Do you have the corrupted file system?
> Right, these bugs need to be narrowed down to be useful.
>=20
When the bug occurred I was neither able to cd into the directory where
the log files resides nor I could do a sync. psgrep and friends hang to=
o.
On the other hand I was able to write an email with thunderbird and sen=
d
it out before I had to power off the system - sysrq key alt+print+b
didn't worked too.

> Does trinity start w/ a random seed, so you can restart?  Or better
> yet, restart w/ that seed and show the last 20 syscalls before the
> bug, etc?
yes - trinity uses a randomly choosen seed. SO a replay is possible lat=
er.
But because the bug occurred after 3 hours /me thinks that a simple
replay with just few syscalls won't work.

> "I threw random garbage at the kernel and something fell off after a
> few hours" is a bit vague.  ;)

yes - I do know that the bug report lacks data to easy reproduce it -
OTOH I thought it is better to report that then to ignore.

To speed up things for fuzzy tests I do use file systems living in a
tempfs. I'll change my scripts to hold at least the main log file of
trinity on a hard disk and came back if I do have useful log data too.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
