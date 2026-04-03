Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D261A37F8BC
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233384; cv=none; b=afj0HhPyiFwVakZcjpsUTBY1ZJiLVESwmuzNcu2+L8JofWe9m5xX5AKszWC2eq0yZJyNCK308WbH7hL3EZCma4Vp3FNH22nYrjWBoHqO82UuTLraLiPRB6KZdGpg8OJ1L6LEgaKpVt/+yDFqMjCJHfhJt4seduR48q5O0sQl08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233384; c=relaxed/simple;
	bh=IrrAEGc4B9N8JyZque1YH7OSxbR+s3po/KmbGZq/WAQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SBJue3AgYRMbyGvtPH9u/l0Myjh5WC/HXYW7m7HSmMGHgWRdjhUnueBqkyBOg2Z4DwTtfj5FASUJfwqjGudBkZSdyB76fLGKcwKUoaiEVIFW7Ai99xhdPIEMlsC7Kw8+YxCDvbIcMyOM06Ov5kLc3HXdMQf2uVHU/CPqroolLCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=xAuLhYE7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="xAuLhYE7"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2aaf59c4f7cso9499335ad.1
        for <linux-ext4@vger.kernel.org>; Fri, 03 Apr 2026 09:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1775233382; x=1775838182; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFcJ2HsUo68s+MMS+uT7cj9w4XwVfLi7pmlIUW+5TVY=;
        b=xAuLhYE7fy0Z5F16L1ZI9VHkAvpEwkY6ZXonSOkoH2nOL7LWhen9Z5KPIbVylZl1di
         GgHnzVXmUnKrA8txwxcfna57IIOiL1+pBLuQc6frIGnKKBCjefg4MQSmPfWBb7TlNxHj
         top0iKyGJs8U+we4MBqRZ4jmzqNz9EVxba/TminE7Lia9h6DN9/BaeLZE6BMCkR2V+2u
         rDe1lDM4cb1VfZTOaai/pp+DjwAuhdNV9FTZyYAB9pJfiSI8ZlmzL4vMg/lE1AD5b2ES
         UgZhYQGChZ2c4usCAGxm2MaUA6Vea+4cj4BSD7+DdxRH7f00yDOj+O2EFgzoFiD1C7Of
         o4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775233382; x=1775838182;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sFcJ2HsUo68s+MMS+uT7cj9w4XwVfLi7pmlIUW+5TVY=;
        b=f0LMVBwpcj1E3LTHKAggWDKCls74J5+HmREBEfElPxsYz85bON45V9EBhjm5tsM850
         n4PWUIPC1XZHJ78L4Xpud+U5z+dVbDQ8As5HbH0uZxNom/sBEmBSAePwgp+nmW9xPkZy
         XWAIIfZfsgjKCL1zQipGkdixxcA2Ik4WwiBguZbMLYw2Cr1x1nfaCHXB0ujZtCz1rVIq
         f8qfZ7OmP2xQdpCZU3s+aNTnci+RK/uTbcw4Aq3to8dr+VbNO+z9RvIWvMn4fClW/k2F
         EsYThKVNOZuFp83dfRYRoXSQ5Jec5rR5crsz1nanwQ8sjJboMdNlt+uUzbrWXuZDsv1Z
         hjDw==
X-Forwarded-Encrypted: i=1; AJvYcCVRlxgXRuXnV0O/DHV/xCqfyGBotW3lgSpzJAAC0nDgWeAxIvH1x6N+p4z+FCN9BuW4/4Uvcu50ghLR@vger.kernel.org
X-Gm-Message-State: AOJu0Yxifg8XpJT650w9pKUXBA+93EQ6rUB1kchDrVHelgRO4yRmeICA
	dh9905qkp7e8LvKSlHZnHMvhppzorH/YBEFVh+9LkSM4HUXRJBT834DQM7xnXgMs5Y4=
X-Gm-Gg: AeBDieu+zL+f3qXB4xewcZkftkKVPMmOrGhCn3Mzyz5rpRSYNmI3NCbvZ8qKRoaThNl
	yUtABq07uVAy0kpxF49tXMLVI5b0UhwqaGQUTzb3wHQg132PycvP38cfdcWBycSvxeWZ/No2696
	K4YI8RkEp5VOOxYhlAilTgX9np6tpxKdkrTkP/9yGtzdojplP0kSzGAEsnXkE4ZzIYS1Rev/84h
	rHuHOPjakesVZL+PvK3O4QsrSmlCzXIB3qw6WD0h3B62l5/Z4Ek99eyNl/CkxHYICWqISHbO/ci
	qrzyK5q0QwgFLPkW3OGizI9npVqSdyL4lxC4FWUt91Iu7hUXqMdQYNw2X3T4ok8RKmch41har4n
	tIGTMkSMV+21tQcqSK6JfnOdCW5ChJrNCizCCCgMdqTyV+Zks3ProDWmcNgvs0vfHhhkulTV4jD
	bSo6PYMNH7M37s8HySscdl+X9/m+49+D6O0kdHY09nKMiRV6zijtVYfgXpZ7/oSChDnOrsCWicz
	RW/UA==
X-Received: by 2002:a17:903:3b84:b0:2b0:6e60:9582 with SMTP id d9443c01a7336-2b2816dc813mr39454425ad.18.1775233382286;
        Fri, 03 Apr 2026 09:23:02 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27475ff56sm60932935ad.22.2026.04.03.09.23.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2026 09:23:01 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 2/3] ext4: show inode orphan list detail information
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260403082507.1882703-3-yebin@huaweicloud.com>
Date: Fri, 3 Apr 2026 10:22:50 -0600
Cc: tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 jack@suse.cz
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCD954BB-DF5A-403D-A368-ADE329D48968@dilger.ca>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
 <20260403082507.1882703-3-yebin@huaweicloud.com>
To: Ye Bin <yebin@huaweicloud.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 3, 2026, at 02:25, Ye Bin <yebin@huaweicloud.com> wrote:
>=20
> From: Ye Bin <yebin10@huawei.com>
>=20
> Some inodes added to the orphan list are due to truncation, while =
others
> are due to deletion.Therefore, we printed the information of inode as
> follows: inode number/i_nlink/i_size/i_blocks/projid/file path. By =
using
> this information, it is possible to quickly identify files that have =
been
> deleted but are still being referenced.

Since the format of this output is still flexible, I would request that
it be formatted in a way that is more easily understood and parsed =
instead
of just an unformatted list of numbers.

Using YAML combines both human and machine readable properties, without
a lot of overhead, something like:

- ino: INUM, link: NLINK, size: SIZE, blocks: BLOCKS, proj: PROJID, =
path: "PATH"
- ino: ...
- ino: ...

The PATH should derfinitely be quoted to avoid issues with spaces and
other special characters in the filename.

Cheers, Andreas

>=20
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
> fs/ext4/orphan.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 86 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index 1d231aeaf282..272de32d1a47 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -662,25 +662,108 @@ int ext4_orphan_file_empty(struct super_block =
*sb)
>=20
> struct ext4_proc_orphan {
> struct ext4_inode_info cursor;
> + bool print_title;
> };
>=20
> -static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
> +static inline bool ext4_is_cursor(struct ext4_inode_info *inode)
> +{
> + return (inode->vfs_inode.i_ino =3D=3D 0);
> +}
> +
> +static struct inode *ext4_list_next(struct list_head *head, struct =
list_head *p)
> {
> + struct ext4_inode_info *inode;
> +
> + list_for_each_continue(p, head) {
> + inode =3D list_entry(p, typeof(*inode), i_orphan);
> + if (!ext4_is_cursor(inode))
> + return &inode->vfs_inode;
> + }
> +
> return NULL;
> }
>=20
> +static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> + struct ext4_proc_orphan *s =3D seq->private;
> + struct super_block *sb =3D pde_data(file_inode(seq->file));
> + struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> + struct list_head *prev;
> +
> + mutex_lock(&sbi->s_orphan_lock);
> +
> + if (!*pos) {
> + prev =3D &sbi->s_orphan;
> + } else {
> + prev =3D &s->cursor.i_orphan;
> + if (list_empty(prev))
> + return NULL;
> + }
> +
> + return ext4_list_next(&sbi->s_orphan, prev);
> +}
> +
> static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, =
loff_t *pos)
> {
> - return NULL;
> + struct super_block *sb =3D pde_data(file_inode(seq->file));
> + struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> + struct inode *inode =3D v;
> +
> + ++*pos;
> +
> + return ext4_list_next(&sbi->s_orphan, &EXT4_I(inode)->i_orphan);
> +}
> +
> +static void ext4_show_filename(struct seq_file *seq, struct inode =
*inode)
> +{
> + struct dentry *dentry;
> +
> + dentry =3D d_find_alias(inode);
> + if (!dentry)
> + dentry =3D d_find_any_alias(inode);
> +
> + if (dentry)
> + seq_dentry(seq, dentry, "\t\n\\");
> + else
> + seq_puts(seq, "unknown");
> +
> + dput(dentry);
> + seq_putc(seq, '\n');
> }
>=20
> static int ext4_orphan_seq_show(struct seq_file *seq, void *v)
> {
> + struct inode *inode =3D v;
> + struct ext4_proc_orphan *s =3D seq->private;
> +
> + if (s->print_title) {
> + seq_puts(seq, "INO\tNLINK\tSIZE\tBLOCKS\tPROJID\tPATH\n");
> + s->print_title =3D false;
> + }
> +
> + seq_printf(seq, "%llu\t%u\t%llu\t%llu\t%u\t",
> +   inode->i_ino, inode->i_nlink,
> +   i_size_read(inode), inode->i_blocks,
> +   __kprojid_val(EXT4_I(inode)->i_projid));
> +
> + ext4_show_filename(seq, inode);
> +
> return 0;
> }
>=20
> static void ext4_orphan_seq_stop(struct seq_file *seq, void *v)
> {
> + struct super_block *sb =3D pde_data(file_inode(seq->file));
> + struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> + struct inode *inode =3D v;
> + struct ext4_proc_orphan *s =3D seq->private;
> +
> + if (inode)
> + list_move_tail(&s->cursor.i_orphan, &EXT4_I(inode)->i_orphan);
> + else
> + list_del_init(&s->cursor.i_orphan);
> +
> + mutex_unlock(&sbi->s_orphan_lock);
> }
>=20
> const struct seq_operations ext4_orphan_seq_ops =3D {
> @@ -703,6 +786,7 @@ static int ext4_seq_orphan_open(struct inode =
*inode, struct file *file)
> private =3D m->private;
> INIT_LIST_HEAD(&private->cursor.i_orphan);
> private->cursor.vfs_inode.i_ino =3D 0;
> + private->print_title =3D true;
> }
>=20
> return rc;
> --=20
> 2.34.1
>=20


Cheers, Andreas





