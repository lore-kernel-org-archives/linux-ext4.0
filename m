From: Valerie Clement <valerie.clement@bull.net>
Subject: Large File Deletion Comparison (ext3, ext4, XFS)
Date: Fri, 27 Apr 2007 15:41:19 +0200
Message-ID: <4631FD7F.9030008@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41249 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbXD0NmO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 09:42:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 1187B19D94C
	for <linux-ext4@vger.kernel.org>; Fri, 27 Apr 2007 15:42:11 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04389-09 for <linux-ext4@vger.kernel.org>;
 Fri, 27 Apr 2007 15:42:09 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id CC0EE19D939
	for <linux-ext4@vger.kernel.org>; Fri, 27 Apr 2007 15:42:08 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As asked by Alex, I included in the test results the file fragmentation=
=20
level and the number of I/Os done during the file deletion.

Here are the results obtained with a not very fragmented 100-GB file:

                  |     ext3       ext4 + extents      xfs
------------------------------------------------------------
  nb of fragments |     796             798             15
  elapsed time    |  2m0.306s        0m11.127s       0m0.553s
                  |
  blks read       |  206600            6416            352
  blks written    |   13592           13064            104
------------------------------------------------------------


And with a more fragmented 100-GB file:

                  |     ext3       ext4 + extents       xfs
------------------------------------------------------------
  nb of fragments |   20297           19841            234
  elapsed time    | 2m18.914s        0m27.429s      0m0.892s
                  |
  blks read       |  225624           25432            592
  blks written    |   52120           50664            872
------------------------------------------------------------


More details on our web site:
http://www.bullopensource.org/ext4/20070404/FileDeletion.html

    Val=E9rie
