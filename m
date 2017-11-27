From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] mke2fs: Fix German translation of mke2fs
Date: Mon, 27 Nov 2017 10:51:19 +0100
Message-ID: <20171127095119.6213-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbdK0JvZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 27 Nov 2017 04:51:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a device mke2fs should work on already contains an ext? filesystem,
mke2fs prints a warning. In German translation the warning doesn't end
with a date string (which is terminated by a newline) and thus the
output comes out mangled like:

mke2fs 1.42.12 (29-Aug-2014)
/dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
„WD20_SL12“
        zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
 eingehängtTrotzdem fortfahren? (j,n)
^^^^^^^^^^^^^ here

Fix the translation to end the printed string with a newline and avoid
superfluous space at the beginning of the line.

Reviewed-by: Bernd Schubert <bernd.schubert@fastmail.fm>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 po/de.po | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Ted, can you please merge this fix? Somehow it keeps getting ignored.

diff --git a/po/de.po b/po/de.po
index 4bbaaf9b611d..8a1ee2d716c2 100644
--- a/po/de.po
+++ b/po/de.po
@@ -8610,9 +8610,11 @@ msgid "Bad magic value in profile_file_data_t"
 msgstr "Ungültige magische Zahl im profile_file_data_t"
 
 #: lib/support/plausible.c:118
+# The second %s refers to a date string ending with a newline. Make the
+# translated string end with a newline as well to maintain output compatibility.
 #, c-format
 msgid "\tlast mounted on %s on %s"
-msgstr "\tzuletzt auf %s auf %s eingehängt"
+msgstr "\tzuletzt auf %s auf %seingehängt.\n"
 
 #: lib/support/plausible.c:121
 #, c-format
-- 
2.12.3
