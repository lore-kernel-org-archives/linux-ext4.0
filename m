From: Valerie Clement <valerie.clement@bull.net>
Subject: Bad performance results with the latest git patches
Date: Fri, 07 Sep 2007 14:24:47 +0200
Message-ID: <46E1430F.3050702@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50030 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965296AbXIGMYi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2007 08:24:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Alex,

running ffsb tests (large files creation) on my system with the latest=20
ext4 git patches against a 2.6.23-rc4 kernel, I've got very bad=20
performance results: the I/O throughput measured on an ext4 filesystem=20
is ten times lower than those measured on an XFS filesystem on the same=
=20
machine.
I have mounted the ext4 filesytem with mballoc, delalloc and=20
data=3Dwriteback options.

dmesg output shows plenty of error messages like this:

EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode=20
#3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), dept=
h=20
0(1)
EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode=20
#3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), dept=
h=20
0(1)
EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode=20
#3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), dept=
h=20
0(1)
EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode=20
#3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), dept=
h=20
0(1)


If I removed the second call to ext4_ext_check_header() in the=20
ext4_ext_search_right() function, the problem disappears, no more error=
=20
messages and better throughput values close to those measured on the XF=
S=20
filesystem.
It seems that the depth value passed in argument is buggy.

In a previous line,
   while (++depth < path->p_depth) {
the depth value is incremented even if we don't enter the loop. Is it=20
the problem ?

Could you check this?
Thanks,
   Val=E9rie
