Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794954847;
	b=fI2HZlBrj9mM+rOit/PaGaFcDyDX0pkwVgPYlfRR0k1rxD5dZE8X8cAVOcff5bV9t1qA
	 rp0B+dRu4Rfj91Kb3eGbwA86uYYCb9F7pZKpf53C4uOnJEaOnymw8Z3ATwtk5EEZuwDUC
	 sjYQeKsiHuiRbIwnzgEAHrAanfUwg+xz/U8ksDZ5FwlWPBIDF8GLE7O4up9GvSlIjkptb
	 XPrR9duyviG+5sDhq7+RJ+g8vTHpS4fqbZ9TSe7OmOmOV6ALcjl4qjeRDblL19diORZzV
	 CxBuaeVFDq6Djn7+hS8rYH9wL13MeNd0fvbNd211p1kGR1hk7Zaqlk3o6YlbUjUceWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794954847;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=GCxH65H4FQ62mFwTtey1RVfgFIJq0ndlu8cwysXMQ4I=;
	b=a506hDdCOGwLDmkybVG4ouZMGc46Nen7VMiYYLjasTzFOiM9eCu3lF56Us/WaLBLm85u
	 GGaY3E1aEPv70crtEuC8KkEmNKbmpO8FmOtPd7sIKy6el++7vxxEhRZ+yVpFAe00XPh3o
	 sYqpyZJ/8C2uLuHSIRMT70G+ewLf1TrmXur33Ujh65qK376oHK2HBhH92jAU9QauwQwW+
	 y2KS46s2zuYl1XV0Mjx2lCnxxzeH0Sn7Q2xWu7JoTmn7HXJmJoOaxqjijg/Ew0otCQWc3
	 E8BZUTqssEGM5Ql2sBYQJN6kcJJzjESKoeth6RFB6aX4v1v+yh6hyM+gCTwk7MJN0hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=logarcheon.com;
	spf=pass smtp.mailfrom=logarcheon.com;
	dkim=pass header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=gXIUilh6;
	arc=none smtp.remote-ip=185.70.43.20
Received: from mail-4320.protonmail.ch (mail-4320.protonmail.ch [185.70.43.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B600606A31C;
	Tue, 17 Nov 2026 22:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B600606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=gXIUilh6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=logarcheon.com;
	s=protonmail3; t=1794954844; x=1795214044;
	bh=GCxH65H4FQ62mFwTtey1RVfgFIJq0ndlu8cwysXMQ4I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=gXIUilh6Q2cgBYgy9DF4YEUFQ3CxXDC/3pDaCXtG5cl8Y0zlMTUzowiLaTkhAV+QD
	 s5Jpg2Ub+9N89YjA9F1VMMuFt5yqW87Cj2m+lNqciRGps1ZXabemhg2J1b82znDXek
	 CNDCT71tM0+CIvNDSCrrDtFYYL5rwTRa2iGFBgDxYMUXldLJ3U/1+cxu9FjLlfNKYO
	 z5j9ScBdHUcjl4Nynz3/fmLUr8CraH2G/S89UVRaafjGmwIkEuq5zPgatcOjMxls2P
	 qCX8FZwnArwxMrlJnkqWe5NCeIGK7jLi/7leZtghXEK7u1tjBRYaaPfccEZqoNoH/M
	 k4Zh3kczFVcAQ==
Date: Tue, 17 Nov 2026 22:33:59 +0000
To: Theodore Ts'o <tytso@mit.edu>
From: William Chuang <founder@logarcheon.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] ext4: reject a non-regular boot loader inode in EXT4_IOC_SWAP_BOOT
Message-ID: <20261117223350.6920-1-founder@logarcheon.com>
In-Reply-To: <20261117065645.4409-1-founder@logarcheon.com>
References: <20261117061822.3826-1-founder@logarcheon.com> <20261117065645.4409-1-founder@logarcheon.com>
Feedback-ID: 145408520:user:proton
X-Pm-Message-ID: 6be07144dda1685a19f8de379cf81a196511ac84
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

swap_inode_boot_loader() gets the boot loader inode (inode 5) with
EXT4_IGET_BAD.  On a new filesystem that inode is unused, its mode is
0, and ext4_iget() returns it as a bad inode, which make_bad_inode()
sets to S_IFREG.  On a corrupted or crafted filesystem, ext4_iget()
can instead return inode 5 as a directory or another non-regular type,
fully set up with that type's inode and file operations.

Such an inode is first passed to lock_two_nondirectories(), which
warns if it is a directory:

  WARNING: fs/inode.c:1271 at lock_two_nondirectories
   swap_inode_boot_loader
   __ext4_ioctl

The "never used as a boot loader" branch then sets inode_bl->i_mode
to S_IFREG, changing the type of a live in-core inode while it keeps
the operations of its old type.

Check the type right after ext4_iget(): report the corruption and
return -EFSCORRUPTED unless the inode is a regular file.  Leave the
cached inode's type unchanged, so that a concurrent caller holding the
same inode rejects it too.  ext4_iget() lets inode 5 through with
i_nlink =3D=3D 0; in that case set i_nlink to 1 in memory, under the inode
lock, so that the final iput() does not send the reserved inode down
the deletion path of ext4_evict_inode().

With non-regular types rejected up front, the later
"is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)" test only needs
is_bad_inode().  The unused
case is unaffected, since make_bad_inode() has already made it
S_IFREG.  This is the check Ted Ts'o suggested when the warning was
first reported.

Tested on UML at 666539eec: inode 5 set with debugfs to a directory
(with i_links_count 1, and with 0) or a character device, then
EXT4_IOC_SWAP_BOOT issued twice.  Before this patch, the directory
cases warn, and all cases succeed and leave inode 5 as a regular file
on disk.  After it, all return EFSCORRUPTED, the error is logged,
inode 5 is unchanged, and no attempt is made to free it.  Two
processes issuing the ioctl concurrently 500 times each against a
directory inode 5 never succeed.  On a
new filesystem the ioctl still succeeds, twice.  Not tested: KASAN
builds and syzbot's 2023 reproducer.

Fixes: 991ed014de08 ("ext4: fix bug_on in __es_tree_search caused by bad bo=
ot loader inode")
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/all/tencent_DABB2333139E8D1BCF4B5D1B2725FABA9=
108@qq.com/T/
Link: https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5
Signed-off-by: William Chuang <founder@logarcheon.com>
---
v3: following Sashiko's review of v2:
    - do not call make_bad_inode() on the rejected inode: it changes the
      type of a cached inode that a concurrent caller may hold, which
      then passes the regular-file check and is swapped.  Instead, when
      i_nlink is 0, set it to 1 in memory under the inode lock, so the
      final iput() does not try to delete inode 5;
    - drop the now redundant !S_ISREG() from the later is_bad_inode()
      test.
    The concurrent case was run on single-CPU UML, where the v2 race did
    not show up either; v3 avoids it by not changing the inode's type.
v2: https://lore.kernel.org/all/20261117065645.4409-1-founder@logarcheon.co=
m/
    mark the rejected inode bad before iput() (Sashiko review of v1).
v1: https://lore.kernel.org/all/20261117061822.3826-1-founder@logarcheon.co=
m/

 fs/ext4/ioctl.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498..41e8934a7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -390,6 +390,30 @@ static long swap_inode_boot_loader(struct super_block =
*sb,
 =09=09return PTR_ERR(inode_bl);
 =09ei_bl =3D EXT4_I(inode_bl);
=20
+=09/*
+=09 * An unused boot loader inode comes back from ext4_iget() as a bad
+=09 * inode, which make_bad_inode() leaves as S_IFREG.  Any other type
+=09 * means the on-disk inode is corrupted; its type cannot be changed
+=09 * in place below.
+=09 */
+=09if (!S_ISREG(inode_bl->i_mode)) {
+=09=09EXT4_ERROR_INODE(inode_bl,
+=09=09=09=09 "boot loader inode is not a regular file (mode 0%o)",
+=09=09=09=09 inode_bl->i_mode);
+=09=09/*
+=09=09 * Leave the type alone: other callers may hold this cached
+=09=09 * inode, and must reject it too.  ext4_iget() lets inode 5
+=09=09 * through with i_nlink =3D=3D 0, so keep the last iput() from
+=09=09 * treating the reserved inode as deleted.
+=09=09 */
+=09=09inode_lock(inode_bl);
+=09=09if (!inode_bl->i_nlink)
+=09=09=09set_nlink(inode_bl, 1);
+=09=09inode_unlock(inode_bl);
+=09=09iput(inode_bl);
+=09=09return -EFSCORRUPTED;
+=09}
+
 =09/* Protect orig inodes against a truncate and make sure,
 =09 * that only 1 swap_inode_boot_loader is running. */
 =09lock_two_nondirectories(inode, inode_bl);
@@ -435,7 +459,7 @@ static long swap_inode_boot_loader(struct super_block *=
sb,
 =09/* Protect extent tree against block allocations via delalloc */
 =09ext4_double_down_write_data_sem(inode, inode_bl);
=20
-=09if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
+=09if (is_bad_inode(inode_bl)) {
 =09=09/* this inode has never been used as a BOOT_LOADER */
 =09=09set_nlink(inode_bl, 1);
 =09=09i_uid_write(inode_bl, 0);
--=20
2.43.0


