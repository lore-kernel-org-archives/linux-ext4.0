From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
Subject: Wrong calculation of space remaining on a 32 bit system.
Date: Sun, 02 Nov 2008 15:40:25 +0100
Message-ID: <490DBBD9.9040300@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mirapoint3.brutele.be ([212.68.199.148]:20800 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYKBOpc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 09:45:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everybody,

I try to use ext4 but I encounter an annoying problem. It seems that
only one third of the filesystem can be used. I have a LVM volume for
the /usr/src directory which currently is formatted as reiserfs. So I
made a compressed tar file of the content. When I uncompress it after
having formatted this volume as ext4, the decompression stops when
appreoximately 600 Mb of space is used. At this time, it's no more
possible to write anything on this volume even if there are 1.4 Gb of
free space remaining.
What seems even stranger is that I encounter this problem only on a 32
bits system. On another computer having an Intel Core 2 Duo and running
a 64 system, the problem doesn't occur.
I have already filed a bug report (see
http://bugzilla.kernel.org/show_bug.cgi?id=3D11840) but unfortunately,
nobody seems to care about it.

I tried the 2.6.28-rc3 or 2.6.27 patched with the ext4-2 patchset but i=
t
 gives the same problem.

Can anybody explains what's happening ?

Thanks in advance for your help.

=46ran=E7ois Valenduc
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
