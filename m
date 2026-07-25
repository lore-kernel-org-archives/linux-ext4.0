Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90BE332628;
	Sat, 25 Jul 2026 01:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784942623; cv=none; b=aQfr6ffWbKYS38S2hvf/KFUZD4S6MCaIK6yy7t70bvU/+NKInOPKel6Xfu0TvBjXGPSbAlGYrT8bMl+ZL+f1X4PJE4sQj8bw9UxAnvZDZEoMC4MRWSXFZ+9RNOo7VzKh5BQ2ii3NFkAZRa/PqUjYCw3fR247pMBKh7+Q2WXJ2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784942623; c=relaxed/simple;
	bh=+y1gH3kClNnzE4lJnRoIGrqEZcKHpynirpgff3NtIyQ=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=qNPih9yaPL7zeY7b/sZm5d11TkKNGWlj/iV0L4GSe3E19khbsGfIaBY2whehaE/VarbtBGg30JiyWZFtkjgCyDVuU1eK2ibeuxcNxGwC1Q2cG/fs/dCT4Yy5z/rtZdc9PXi4Eo+bsdDcDy9JGcJ/4onXIP5feczy/1r1orR3i/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BD0E1A0167;
	Sat, 25 Jul 2026 01:23:40 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf10.hostedemail.com (Postfix) with ESMTPA id 5C42730;
	Sat, 25 Jul 2026 01:23:37 +0000 (UTC)
Message-ID: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
Subject: [PATCH] ext4: Reduce object size of ext4_msg uses
From: Joe Perches <joe@perches.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li	
 <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo	
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, LKML
 <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jul 2026 18:23:36 -0700
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 5C42730
X-Stat-Signature: pefdp6fs95jpmbntfqy31rhscxywne78
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19u+HKVXOdS7IJ05XJhMw3kwRUznZ3EK2U=
X-HE-Tag: 1784942617-13501
X-HE-Meta: U2FsdGVkX19x+9g/NY/c7sILWT9aNZhOHX+BZt4wEDFYJSoH2K6LIQgIgJ8/jcGUI6/0goaq/0nn6OEr8+AMdYZudhCGJlbgu4kEn1b4sUYk8hQ0Zy+Mhb10A/nyiPngfmr6bAmirEgeMVJAfLX1tilurp4VskEt5wXPkj8jB5YuutT94GYvahdm80rep53ND1pWRXKgX1lcPYhOtC/wK+nQWU4WUjUarclsMPhZSc1O/VMBWB4taNInm2F6zx6uZnNMl3vXsKj1GIz4sWnoG3aDgp+gYWuznGHtBNlp2G48SIxT7uCubyxGUflKIIvL3CK3wdKR3n7z0Iva6/qHv/wnBg7mFGUV7xb+iiVA/M0W1AziElG36VqYjQ6VbEqT

Reduce the object size of ext4 ~2KB (~.5%) by combining the KERN_<LEVEL>
and format uses of ext4_msg.

Separate them in __ext4_msg using printk_get_level and printk_skip_level
and emitting the appropriate level.

x86 object sizes before and after:

defconfig size before:
$ size -t fs/ext4/built-in.a | tail -1
 579013	 121634	    316	 700963	  ab223	(TOTALS)

defconfig size after:
$ size -t fs/ext4/built-in.a | tail -1
 577196	 121650	    316	 699162	  aab1a	(TOTALS)

defconfig size before with CONFIG_EXPERT=3Dy and CONFIG_PRINTK=3Dn:
$ size -t fs/ext4/built-in.a | tail -1
 537999	 121432	    316	 659747	  a1123	(TOTALS)

defconfig size after with CONFIG_EXPERT=3Dy and CONFIG_PRINTK=3Dn:
$ size -t fs/ext4/built-in.a | tail -1
 536837	 121424	    316	 658577	  a0c91	(TOTALS)

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/ext4.h  | 12 ++++++------
 fs/ext4/super.c | 14 +++++++++-----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..981918f32067 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3309,8 +3309,8 @@ void __ext4_warning(struct super_block *, const char =
*, unsigned int,
 extern __printf(4, 5)
 void __ext4_warning_inode(const struct inode *inode, const char *function,
 			  unsigned int line, const char *fmt, ...);
-extern __printf(3, 4)
-void __ext4_msg(struct super_block *, const char *, const char *, ...);
+extern __printf(2, 3)
+void __ext4_msg(struct super_block *, const char *fmt, ...);
 extern void __dump_mmp_msg(struct super_block *, struct mmp_struct *mmp,
 			   const char *, unsigned int, const char *);
 extern __printf(7, 8)
@@ -3354,8 +3354,8 @@ void __ext4_grp_locked_error(const char *, unsigned i=
nt,
 	__ext4_warning(sb, __func__, __LINE__, fmt, ##__VA_ARGS__)
 #define ext4_warning_inode(inode, fmt, ...)				\
 	__ext4_warning_inode(inode, __func__, __LINE__, fmt, ##__VA_ARGS__)
-#define ext4_msg(sb, level, fmt, ...)				\
-	__ext4_msg(sb, level, fmt, ##__VA_ARGS__)
+#define ext4_msg(sb, level, fmt, ...)					\
+	__ext4_msg(sb, level fmt, ##__VA_ARGS__)
 #define dump_mmp_msg(sb, mmp, msg)					\
 	__dump_mmp_msg(sb, mmp, __func__, __LINE__, msg)
 #define ext4_grp_locked_error(sb, grp, ino, block, fmt, ...)		\
@@ -3401,8 +3401,8 @@ do {									\
 } while (0)
 #define ext4_msg(sb, level, fmt, ...)					\
 do {									\
-	no_printk(fmt, ##__VA_ARGS__);					\
-	__ext4_msg(sb, "", " ");					\
+	no_printk(level fmt, ##__VA_ARGS__);				\
+	__ext4_msg(sb, "" " ");						\
 } while (0)
 #define dump_mmp_msg(sb, mmp, msg)					\
 	__dump_mmp_msg(sb, mmp, "", 0, "")
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..72d6f6353a27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -981,11 +981,11 @@ void __ext4_std_error(struct super_block *sb, const c=
har *function,
 	ext4_handle_error(sb, false, -errno, 0, 0, function, line);
 }
=20
-void __ext4_msg(struct super_block *sb,
-		const char *prefix, const char *fmt, ...)
+void __ext4_msg(struct super_block *sb, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
+	int level;
=20
 	if (sb) {
 		atomic_inc(&EXT4_SB(sb)->s_msg_count);
@@ -995,12 +995,16 @@ void __ext4_msg(struct super_block *sb,
 	}
=20
 	va_start(args, fmt);
-	vaf.fmt =3D fmt;
+
+	level =3D printk_get_level(fmt);
+	vaf.fmt =3D printk_skip_level(fmt);
 	vaf.va =3D &args;
 	if (sb)
-		printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
+		printk("%c%cEXT4-fs (%s): %pV\n",
+		       KERN_SOH_ASCII, level, sb->s_id, &vaf);
 	else
-		printk("%sEXT4-fs: %pV\n", prefix, &vaf);
+		printk("%c%cEXT4-fs: %pV\n",
+		       KERN_SOH_ASCII, level, &vaf);
 	va_end(args);
 }
=20
