From: Valerie Clement <valerie.clement@bull.net>
Subject: Problems with mballoc and uninit_groups option
Date: Fri, 11 Jan 2008 15:04:08 +0100
Message-ID: <47877758.1070603@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34001 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYAKOCg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2008 09:02:36 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id C316F19D920
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 15:02:41 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 06226-07 for <linux-ext4@vger.kernel.org>;
 Fri, 11 Jan 2008 15:02:38 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 7C0BD19D90B
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 15:02:38 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've got problems with mballoc when I create the ext4 filesystem with=20
the "uninit_groups" option enabled.

=46irst, I do a single test on a filesystem created without the=20
"uninit_groups" option and mounted with the defaults option:
   dd if=3D/dev/zero of=3D/mnt/test/foo bs=3D1M count=3D1024

In this case, the file blocks are allocated in the groups 4, 5, 6, 7, 8=
,=20
9, 10.

When the filesystem is created with the "uninit_groups" option enabled=20
and mounted with the defaults option, I do the same dd command.

In this case, the file blocks are allocated in the groups 5, 7, 9, 25,=20
27, 49, 81. It seems that the blocks could be allocated only in the=20
already initialized groups.

Who knows how to fix that?

   Val=E9rie
