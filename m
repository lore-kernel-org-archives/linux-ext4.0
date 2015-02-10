From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2, RFC] ext4: ignore journal checksum on remount; don't
 fail
Date: Tue, 10 Feb 2015 10:48:46 -0600
Message-ID: <54DA366E.8060109@redhat.com>
References: <54DA34BB.8030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>,
	=?UTF-8?B?Q8OzbnLDpGQ=?= <conradsand.arma@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbbBJQst (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2015 11:48:49 -0500
In-Reply-To: <54DA34BB.8030806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As of v3.18, ext4 started rejecting a remount which changes the
journal_checksum option.

Prior to that, it was simply ignored; the problem here is that
if someone has this in their fstab for the root fs, now the box
fails to boot properly, because remount of root with the new options
will fail, and the box proceeds with a readonly root.

I think it is a little nicer behavior to accept the option, but
warn that it's being ignored, rather than failing the mount,
but that might be a subjective matter...

Reported-by: C=C3=B3nr=C3=A4d <conradsand.arma@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

ALSO: Not tested.  Please double check my mad bitwise skillz to
be sure I'm re-setting the option properly.  ;)  Thanks!

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f300a56..250ad25 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4853,9 +4853,8 @@ static int ext4_remount(struct super_block *sb, i=
nt *flags, char *data)
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-			 "during remount not supported");
-		err =3D -EINVAL;
-		goto restore_opts;
+			 "during remount not supported; ignoring");
+		sbi->s_mount_opt ^=3D EXT4_MOUNT_JOURNAL_CHECKSUM;
 	}
=20
 	if (test_opt(sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_JOURNAL_DATA) {

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
