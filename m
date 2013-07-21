From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: fuzzying a user mode linux image often core dumps with
Date: Sun, 21 Jul 2013 13:14:13 +0200
Message-ID: <51EBC285.2030104@gmx.de>
References: <51EAA7A7.4000104@gmx.de> <20130721010352.GB21484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	"user-mode-linux-devel@lists.sourceforge.net"
	<user-mode-linux-devel@lists.sourceforge.net>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55371 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3GULOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jul 2013 07:14:15 -0400
Received: from [80.171.226.24] ([80.171.226.24]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0M1msU-1U77JE0ANG-00tkot for
 <linux-ext4@vger.kernel.org>; Sun, 21 Jul 2013 13:14:14 +0200
In-Reply-To: <20130721010352.GB21484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/21/2013 03:03 AM, Theodore Ts'o wrote:
> On Sat, Jul 20, 2013 at 05:07:19PM +0200, Toralf F=C3=B6rster wrote:
>> I do run the fuzzer trinity within a 32 bit user mode linux.
>> With latest git tree I do often get a core dump like the one attache=
d.
>>
>> Although it is the nature of trinity to corrupt the kernel /me wonde=
rs why it happens nearly alway
>> at the same place. That's why I decided to just report it here.
>=20
> Thanks, this is a known problem for which the fix is can be found her=
e:
>=20
> 	http://patchwork.ozlabs.org/patch/260250/
>=20
Ah - so no bisecting necessary.

> I hope to get this fixed before -rc2 is released; the only question a=
t
> the moment is whether the fix is going to go to Linus via the ext4
> tree or the VFS tree....

yep - Linus had it now in its tree-.

BTW that issue seems to be the reason for a lot of erratically crashes
of an UML while fuzzy tested.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
