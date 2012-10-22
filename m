From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Mon, 22 Oct 2012 20:36:47 +0200
Message-ID: <5085923F.9050801@gmx.de>
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:43575 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755771Ab2JVSjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2012 14:39:40 -0400
In-Reply-To: <20121019210723.GA4721@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/19/2012 11:07 PM, Theodore Ts'o wrote:
> On Mon, Oct 15, 2012 at 07:46:02PM +0200, Toralf F=C3=B6rster wrote:
>> Even with current stable kernel 3.6.2 I sometimes get those syslog m=
essages :
>>
>>
>> 2012-10-15T19:37:58.401+02:00 n22 kernel: EXT4-fs error (device sdb3=
): ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 229=
01 in gd
>=20
> Have you run e2fsck to clean up the file system corruption?  If you
> have, do you continually get these errors afterwards?

Well, I got it yesterday too :

n22 ~ # zgrep  ext4_mb_generate_buddy /var/log/messages-201210*        =
                                                                       =
                                       =20
/var/log/messages-20121021.gz:2012-10-15T19:05:39.189+02:00 n22 kernel:=
 EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 774, 27=
157 clusters in bitmap, 27052 in gd      =20
/var/log/messages-20121021.gz:2012-10-15T19:37:58.401+02:00 n22 kernel:=
 EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 436, 22=
902 clusters in bitmap, 22901 in gd      =20
/var/log/messages-20121021.gz:2012-10-15T19:56:05.301+02:00 n22 kernel:=
 EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 1233, 1=
1981 clusters in bitmap, 11974 in gd     =20
/var/log/messages-20121021.gz:2012-10-15T19:56:18.601+02:00 n22 kernel:=
 EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 484, 28=
817 clusters in bitmap, 28101 in gd     =20

I rebooted the system and forced a run of fsck after these lines too.
I'll check periodically whether it happens again.
=20
> You say this is an external USB disk; is there any possibility of the
> disk getting unmounted uncleanly due to the cable getting pulled out
> while the disk is still mounted, and then the disk getting remounted
> w/o having e2fsck run on the disk?

=46or the first occurrence probably yes (better : I dunno), but yesterd=
ay definitely not.



--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
