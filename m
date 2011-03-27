From: Christian Brandt <brandtc@psi5.com>
Subject: fsck.ext4 taking months
Date: Sun, 27 Mar 2011 13:28:53 +0200
Message-ID: <4D8F1F75.8010201@psi5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:40100 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1C0L2z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Mar 2011 07:28:55 -0400
Received: from frontend1.mail.m-online.net (frontend1.mail.intern.m-online.net [192.168.8.180])
	by mail-out.m-online.net (Postfix) with ESMTP id 0E6AA188A177
	for <linux-ext4@vger.kernel.org>; Sun, 27 Mar 2011 13:28:53 +0200 (CEST)
Received: from sword.brandt.rfc1918 (ppp-188-174-94-32.dynamic.mnet-online.de [188.174.94.32])
	by mail.mnet-online.de (Postfix) with ESMTP id DD2B81C00106
	for <linux-ext4@vger.kernel.org>; Sun, 27 Mar 2011 13:28:53 +0200 (CEST)
Received: from [10.0.3.1] (gate.lan.brandt.rfc1918 [10.0.3.1])
	by sword.brandt.rfc1918 (Postfix) with ESMTP id 931CF20A5C
	for <linux-ext4@vger.kernel.org>; Sun, 27 Mar 2011 13:28:53 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Situation: External 500GB drive holds lots of snapshots using lots of
hard links made by rsync --link-dest. The controller went bad and
destroyed superblock and directory structures. The drive contains
roughly a million files and four complete directory-tree-snapshots with
each roughly a million hardlinks.

Tried

e2fsck 1.41.12 (17-May-2010)
        Benutze EXT2FS Library version 1.41.12, 17-May-2010

e2fsck 1.41.11 (14-Mar-2010)
        Benutze EXT2FS Library version 1.41.11, 14-Mar-2010

Symptoms: fsck.ext4 -y -f takes nearly a month to fix the structures on
a P4@2,8Ghz, with very little access to the drive and 100% cpu use.

output of fsck looks much like this:

=46ile ??? (Inode #123456, modify time Wed Jul 22 16:20:23 2009)
  block Nr. 6144 double block(s), used with four file(s):
    <filesystem metadata>
    ??? (Inode #123457, mod time Wed Jul 22 16:20:23 2009)
    ??? (Inode #123458, mod time Wed Jul 22 16:20:23 2009)
    ...
multiply claimed block map? Yes

Is there an adhoc method of getting my data back faster?

Is the slow performance with lots of hard links a known issue?

--=20
mit freundlichen Gr=FC=DFen,

Christian Brandt EDV-Dienstleistungen
Tel 089/89427711, Fax 089/89427712
Kreuzlinger Str.37 82110 Germering
St.Nr. 117/206/91819 Ust-ID DE233256795
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
