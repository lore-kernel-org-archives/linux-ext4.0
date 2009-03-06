From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix incorrect .de translation file
Date: Fri, 06 Mar 2009 11:21:03 -0600
Message-ID: <49B15B7F.4000200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCFRVG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Mar 2009 12:21:06 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n26HL4WD025653
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 12:21:04 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n26HL4Gt012818
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 12:21:05 -0500
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n26HL4GT021612
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 12:21:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The translation for this e2fsprogs output:

This filesystem will be automatically checked every 34 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

comes out as:

Das Dateisystem wird automatisch alle 25 Mounts bzw. alle 180 Tage =FCb=
erpr=FCft,
je nachdem, was zuerst eintritt. Ver=E4nderbar mit tune2fs -c oder -t .

-t is not even a valid option for tune2fs...

Resolves-rh-bugzilla: 488960
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/po/de.po
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- e2fsprogs.orig/po/de.po
+++ e2fsprogs/po/de.po
@@ -4895,7 +4895,7 @@ msgid ""
 msgstr ""
 "Das Dateisystem wird automatisch nach jeweils %d Einh=E4ng-Vorg=E4nge=
n bzw.\n"
 "alle %g Tage =FCberpr=FCft, je nachdem, was zuerst eintritt. Ver=E4nd=
erbar mit\n"
-"tune2fs -c oder -t .\n"
+"tune2fs -c oder -i .\n"
=20
 #: misc/uuidgen.c:31
 #, c-format

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
