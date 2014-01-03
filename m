From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: small .de translation fix
Date: Fri, 03 Jan 2014 12:43:56 -0600
Message-ID: <52C704EC.8000501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaACSn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 13:43:58 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s03IhwVV016564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jan 2014 13:43:58 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s03IhuKS029239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jan 2014 13:43:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was reported in RH bugzilla.  I think my German is good enough
that the fix is correct, but I don't mind a double-check.  :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/po/de.po b/po/de.po
index d1ed005..d0b357a 100644
--- a/po/de.po
+++ b/po/de.po
@@ -1840,7 +1840,7 @@ msgid ""
 "  has %r @m @b(s), shared with %N file(s):\n"
 msgstr ""
 "Datei %Q (@i #%i, =C4nderungszeit %IM) \n"
-"  hat %r mehrfach belegte(n) Block/B=F6cke, gemeinsam genutzt mit %N =
Datei(en):\n"
+"  hat %r mehrfach belegte(n) Block/Bl=F6cke, gemeinsam genutzt mit %N=
 Datei(en):\n"
=20
 #. @-expanded: \t%Q (inode #%i, mod time %IM)\n
 #: e2fsck/problem.c:1011
@@ -5274,7 +5274,7 @@ msgstr "Das Intervall zwischen zwei Checks wird a=
uf %lu Sekunden gesetzt\n"
 #: misc/tune2fs.c:2016
 #, c-format
 msgid "Setting reserved blocks percentage to %g%% (%llu blocks)\n"
-msgstr "Der Prozentsatz reservierter B=F6cke wird auf %g%% (%llu Bl=F6=
cke) gesetzt\n"
+msgstr "Der Prozentsatz reservierter Bl=F6cke wird auf %g%% (%llu Bl=F6=
cke) gesetzt\n"
=20
 #: misc/tune2fs.c:2022
 #, c-format

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
