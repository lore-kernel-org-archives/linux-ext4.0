From: Jan Kara <jack@suse.cz>
Subject: [PATCH] mke2fs: Fix German translation of mke2fs
Date: Tue, 27 Jan 2015 10:19:15 +0100
Message-ID: <1422350355-21997-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbbA0JTV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 04:19:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a device mke2fs should work on already contains an ext? filesystem=
,
mke2fs prints a warning. In German translation the warning doesn't end
with a date string (which is terminated by a newline) and thus the
output comes out mangled like:

mke2fs 1.42.12 (29-Aug-2014)
/dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
=E2=80=9EWD20_SL12=E2=80=9C
        zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
 eingeh=C3=A4ngtTrotzdem fortfahren? (j,n)
^^^^^^^^^^^^^ here

=46ix the translation to end the printed string with a newline and avoi=
d
superfluous space at the beginning of the line.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 po/de.po | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/po/de.po b/po/de.po
index fd96bb17f712..cf34daf428f2 100644
--- a/po/de.po
+++ b/po/de.po
@@ -5778,9 +5778,11 @@ msgid "Proceed anyway? (y,n) "
 msgstr "Trotzdem fortfahren? (j,n) "
=20
 #: misc/util.c:132
+# The second %s refers to a date string ending with a newline. Make th=
e
+# translated string end with a newline as well to maintain output comp=
atibility.
 #, c-format
 msgid "\tlast mounted on %s on %s"
-msgstr "\tzuletzt auf %s auf %s eingeh=C3=A4ngt"
+msgstr "\tzuletzt auf %s auf %seingeh=C3=A4ngt.\n"
=20
 #: misc/util.c:135
 #, c-format
--=20
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
