From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: fs/ext4/inode.c::mpage_map_and_submit_extent - unused variable
 warning
Date: Sun, 7 Jul 2013 11:54:55 +0200
Message-ID: <20130707115455.274b50dc@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44723 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3GGJzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Jul 2013 05:55:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

gcc 4.6.3 says:
fs/ext4/inode.c: In function =E2=80=98ext4_writepages=E2=80=99:
fs/ext4/inode.c:2219:6: warning: =E2=80=98err=E2=80=99 may be used unin=
itialized in this function [-Wuninitialized]
fs/ext4/inode.c:2161:6: note: =E2=80=98err=E2=80=99 was declared here

It would be an actual bug if mpage_map_and_submit_extent(handle, mpd, .=
=2E.)
can be called with mpd->map.m_len =3D=3D 0.  Can it?
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D=3D-=3D -=3D=3D=3D --=3D=3D=3D
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
