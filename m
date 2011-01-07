From: Jens Kasten <igraltist@rsbac.org>
Subject: trim support on 2.6.37
Date: Fri, 07 Jan 2011 23:52:18 +0100
Message-ID: <1294440738.15738.12.camel@jaschtschik-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.rsbac.org ([81.169.183.215]:35812 "EHLO www.rsbac.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab1AGXAS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 18:00:18 -0500
Received: from localhost (localhost [127.0.0.1])
	by www.rsbac.org (Postfix) with ESMTP id 29FE01F846
	for <linux-ext4@vger.kernel.org>; Fri,  7 Jan 2011 23:53:42 +0100 (CET)
Received: from www.rsbac.org ([127.0.0.1])
 by localhost (www.rsbac.org [127.0.0.1]) (amavisd-maia, port 10024)
 with ESMTP id 01799-09 for <linux-ext4@vger.kernel.org>;
 Fri,  7 Jan 2011 23:53:36 +0100 (CET)
Received: from [192.168.1.5] (stgt-5f73b91a.pool.mediaWays.net [95.115.185.26])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by www.rsbac.org (Postfix) with ESMTPSA id 38A401F7C9
	for <linux-ext4@vger.kernel.org>; Fri,  7 Jan 2011 23:53:36 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

It is the first time the i write to this list.
I am not sure if it the right place.

I use the kernel 2.6.37 with cryptsetup and lvm on a intel ssd.=20
In the logfile after booting i see this entry:
EXT4-fs (dm-1): re-mounted. Opts: discard,errors=3Dremount-ro
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: discar=
d
EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: discar=
d
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: discar=
d
EXT4-fs warning (device dm-1): ext4_issue_discard:2619: discard not
supported, disabling
EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
supported, disabling
EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
supported, disabling
EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
supported, disabling
EXT4-fs (sda1): re-mounted. Opts: discard,commit=3D0
EXT4-fs (dm-3): re-mounted. Opts: discard,commit=3D0
EXT4-fs (dm-2): re-mounted. Opts: discard,commit=3D0

The mount command shows:
/dev/mapper/System2-root_ssd on / type ext2
(rw,noatime,errors=3Dremount-ro,barrier=3D1,stripe=3D32,data=3Dordered,=
discard)
and the corresponding entry from fstab:
UUID=3D"635a1ad9-9ebb-4d1e-b8c3-30e11148bd92"	/		    ext4
noatime,discard,errors=3Dremount-ro		0	1

My question is now, I don't have trim support now?

Viele Gr=C3=BCsse
Jens Kasten

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
