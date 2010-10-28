From: Ingo Molnar <mingo@elte.hu>
Subject: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Date: Thu, 28 Oct 2010 09:56:31 +0200
Message-ID: <20101028075631.GA7690@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:37938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab0J1H4k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 03:56:40 -0400
Content-Disposition: inline
In-Reply-To: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


hi Ted,

> Theodore Ts'o (18):
>       ext4: rename {exit,init}_ext4_*() to ext4_{exit,init}_*()

Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: rena=
me=20
{exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config w=
ith=20
CONFIG_EXT4_FS_XATTR disabled:

  fs/ext4/super.c:4776: error: implicit declaration of function =E2=80=98=
ext4_init_xattr=E2=80=99

Commit 5dabfc7 renamed init_ext4_xattr to ext4_init_xattr but forgot to=
 update the=20
definition in fs/ext4/xattr.h. The patch below fixes it.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

--- linux.orig/fs/ext4/xattr.h
+++ linux/fs/ext4/xattr.h
@@ -122,7 +122,7 @@ ext4_xattr_put_super(struct super_block=20
 }
=20
 static __init inline int
-init_ext4_xattr(void)
+ext4_init_xattr(void)
 {
 	return 0;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
