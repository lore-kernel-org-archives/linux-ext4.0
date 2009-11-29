From: =?ISO-8859-1?Q?J=E9r=E9my_Cochoy?= <jeremy.cochoy@gmail.com>
Subject: [PATCH] fs/ext2: ext2_readdir comment about returns
Date: Mon, 30 Nov 2009 00:30:55 +0100
Message-ID: <a229bc400911291530s51e1971do402e6441115d70ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Pavel Machek <pavel@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>, ronny.pretzsch@dfs.de,
	Corentin Chary <corentin.chary@gmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:49005 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZK2XbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Nov 2009 18:31:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom:Jeremy Cochoy <jeremy.cochoy@gmail.com>

Hello,

I submit a short correction about a comment in ext2/dir.c

(I've already send it but it wasn't the good patch format and i didn't
cc the right people.)

PS: Please excuse me if I make mistakes with the netiquette, it's my
first patch and i wich to send more useful patchs next time, without
hurting your eyes.

Best regards,

-----
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 6cde970..fc2bd05 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -353,8 +353,8 @@ ext2_readdir (struct file * filp, void * dirent,
filldir_t filldir)
=A0* ext2_find_entry()
=A0*
=A0* finds an entry in the specified directory with the wanted name. It
- * returns the page in which the entry was found, and the entry itself
- * (as a parameter - res_dir). Page is returned mapped and unlocked.
+ * returns the page in which the entry was found (as a parameter - res=
_page),
+ * and the entry itself. Page is returned mapped and unlocked.
=A0* Entry is guaranteed to be valid.
=A0*/
struct ext2_dir_entry_2 *ext2_find_entry (struct inode * dir,

--
J=E9r=E9my Cochoy - L1 MI (Lyon1)
Mail : jeremy.cochoy@gmail.com
Tel : 06-43-01-74-02
Alias Zenol - http://zenol.fr
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
