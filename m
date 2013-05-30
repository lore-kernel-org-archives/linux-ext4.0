From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: found a scenario for BUG at fs/ext4/super.c:804!
Date: Thu, 30 May 2013 20:06:20 +0200
Message-ID: <51A7951C.5020300@gmx.de>
References: <51A79353.7030604@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55668 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab3E3SGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 14:06:24 -0400
Received: from mailout-de.gmx.net ([10.1.76.29]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LgKlO-1U3IJV2efs-00ngaM for
 <linux-ext4@vger.kernel.org>; Thu, 30 May 2013 20:06:21 +0200
In-Reply-To: <51A79353.7030604@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/30/2013 07:58 PM, Toralf F=C3=B6rster wrote:
> 11. if that attempt fails stop the nfs service and run the umount com=
mand again - it segfaults now

forgot to mention that after that just sysrq+b thelps me to reboot the
machine, a "sync" does not come back nor can be interrupted with Ctrl-C=
,
"reboot" don't work too - OTOH I'm able to write an email and save it a=
s
a draft.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
