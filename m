Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46C43BDA7
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785184904; cv=none; b=Ucx6QRjNF2L8ihdxrkSFqGRBXjDp/pT05leT8NH/RTkCg458eBh97fC9ezRaQkZZm2yFVR/Bnnq2t0KcvsK6em6VLS28WpwILgG0sNoR3uJMHjHtknKxnwh8Upk8M1+dWsRXHGEltWchbVz5oXdqDSHgxEvB+PpXy8uhdlbERMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785184904; c=relaxed/simple;
	bh=0wsQTXzJ9wOrPq/FzM/EhipAwlT/mWRB9wbcUZ2z4Sg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Oe3LLNgrlRU5XmVIm1gcjJ+NsbLBKZTZEA1vc3a9ZS1PmNQSH5WMFRoJBALRDx/kcksUmG2B5hXMAJKZGtJ24dIlK316tGhLCzRoEeYcnz3HkZkcMkLJh7m5TPk5+RIc5sVoj4hgHn2pxy3kB6yRbjXQA70L5N7stsE1L3Sb70M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=evP0F8/o; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="evP0F8/o"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-848595b338cso3452957b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 13:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1785184901; x=1785789701; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3Kj0f/ue6IlEBdfJ/t1JIlp3LjIQ0RDxm6jJeDiIBkA=;
        b=evP0F8/oqcLwucMoiRIJ90QmV91XRxXgrcyqgXtaEZvBeYbc8u1fxWFgAovMcokSKx
         e42wqVMsH79wZILTu1sjjPvVkFVji6qzYf2XJK1Pml6CC0Bev/O8ZOgd3GTPXWc/ghQp
         U0e+y3TbLv/rjvLHa2aEGNGGbT7jP/nNwzFW0TQK10wdtkWDlTGQvXjG8Xvm3oaRUBhL
         hNydJ7Zw5oN4xGTpYNEgf3TnH+JHLdfcM72I7EnUrLqzBU2cbSb9E0RPDYEt2mQF8Sw3
         bM1JK6fKiDsehA1vM0AqiQBd7S9zWTOnkRWZku+rmT1Leicjzpjv5ZPYT2wq5MFggmWH
         4TZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785184901; x=1785789701;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Kj0f/ue6IlEBdfJ/t1JIlp3LjIQ0RDxm6jJeDiIBkA=;
        b=PXtJto+hV1XfS9/mdjzh7gPYC6P8CtuGM3mcoKqTFQqNIqFmKKNsZlr4XByIVQM0ba
         cNsa1upLA0SuiyzpFPV5SA994DshQWFKlgNpzFdAokA0djMXuht8LZhBW0KcaYQthVU0
         3O85VY8ithciL/Nyfe1XEoLAvQWmfCBtfVEu9ZQUomWcxrlxrrG7hlZK50yaJJzQ7PsK
         9TXC3OPrmTLBw3WhyHhVd/HSUHzC6vuHDWq9WzbT77etHQp5ZouG1PZAqIzgPZxeWq+5
         a3+8jKhhHQGiebytXS8vqVNpaEBq9lsLBX5pht9mgNKpjnKz+Pf4QSeJ72PR5vtdDZfS
         kQzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrgvnt0CUDjXkK64Ra+RyksUq+iqxcWy9acJ6oo3Fp6gT/gN3qWi9VhRAmXhq0/QXM8g7FK+QaDzb5X@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjbz4MBNP2MRKGTWWfvPGi4OMYwZt0S3OzrZD81Th9pP/flQCB
	V2CNLOXDIsQ6Qv2Umq02ZnPXGTyl2qOwnx9ChEPekJlA8MFBI5epNudp3Za3viHnjTQ=
X-Gm-Gg: AR+sD100r22zlDQVjAS+zTto8c2tLrE3efP7gqxkI3Gj2nY00V4/HaAshfi5vySyoZq
	NGtNXs6lQXWnnI++blppIVQpw9MkRvWHaLTdCfOL+azu2zPHbAPw8a7K+8xyL67F7AI4fpuBVH/
	4oP3pmSZ7B4DI1zeVyrfWWgU/gQy20cl4m2VcUpPdIFvia9gBG0t3HFSJ8kOxJ+0Tu3QFxkVuWw
	Aefi/Ksrip434UWKRNX8xd3wx+f5JBx8bIo0mVCa25TIkj3LHwRzW/SJq06kIxPSR3BqbNd2zUf
	H7XVBRwQ717w8RJjK65/dxCtES25iS+qhQ43oFn6kgE81+2FhbWEufMOXDC6N3HtI6eT7vHfpBp
	VgoGrUHXbDZVZHTE4lGSnjx1o/eg/oonyIxtho48Fkgj0Qvz7ozOlnP8fqsX8YQqjA3nhQrHa5u
	dNbrvw9PqOnVqBt27ABRVJ5aDN5u/zT70=
X-Received: by 2002:a05:6a00:8c2:b0:842:5a8d:3035 with SMTP id d2e1a72fcca58-84e8cf8fe32mr843389b3a.22.1785184901141;
        Mon, 27 Jul 2026 13:41:41 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:8dd9:aaf6:ec3f:4188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53426628sm3541619b3a.49.2026.07.27.13.41.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2026 13:41:40 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: Reduce object size of ext4_msg uses
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
Date: Mon, 27 Jul 2026 14:41:29 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 Baokun Li <libaokun@linux.alibaba.com>,
 Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>,
 linux-ext4@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD404D5A-AF59-4960-8CEF-D150198DCDB9@dilger.ca>
References: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 24, 2026, at 19:23, Joe Perches <joe@perches.com> wrote:
>=20
> Reduce the object size of ext4 ~2KB (~.5%) by combining the =
KERN_<LEVEL>
> and format uses of ext4_msg.
>=20
> Separate them in __ext4_msg using printk_get_level and =
printk_skip_level
> and emitting the appropriate level.
>=20
> x86 object sizes before and after:
>=20
> defconfig size before:
> $ size -t fs/ext4/built-in.a | tail -1
> 579013 121634    316 700963  ab223 (TOTALS)
>=20
> defconfig size after:
> $ size -t fs/ext4/built-in.a | tail -1
> 577196 121650    316 699162  aab1a (TOTALS)
>=20
> defconfig size before with CONFIG_EXPERT=3Dy and CONFIG_PRINTK=3Dn:
> $ size -t fs/ext4/built-in.a | tail -1
> 537999 121432    316 659747  a1123 (TOTALS)
>=20
> defconfig size after with CONFIG_EXPERT=3Dy and CONFIG_PRINTK=3Dn:
> $ size -t fs/ext4/built-in.a | tail -1
> 536837 121424    316 658577  a0c91 (TOTALS)
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/ext4.h  | 12 ++++++------
> fs/ext4/super.c | 14 +++++++++-----
> 2 files changed, 15 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..981918f32067 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3309,8 +3309,8 @@ void __ext4_warning(struct super_block *, const =
char *, unsigned int,
> extern __printf(4, 5)
> void __ext4_warning_inode(const struct inode *inode, const char =
*function,
>  unsigned int line, const char *fmt, ...);
> -extern __printf(3, 4)
> -void __ext4_msg(struct super_block *, const char *, const char *, =
...);
> +extern __printf(2, 3)
> +void __ext4_msg(struct super_block *, const char *fmt, ...);
> extern void __dump_mmp_msg(struct super_block *, struct mmp_struct =
*mmp,
>   const char *, unsigned int, const char *);
> extern __printf(7, 8)
> @@ -3354,8 +3354,8 @@ void __ext4_grp_locked_error(const char *, =
unsigned int,
> __ext4_warning(sb, __func__, __LINE__, fmt, ##__VA_ARGS__)
> #define ext4_warning_inode(inode, fmt, ...) \
> __ext4_warning_inode(inode, __func__, __LINE__, fmt, ##__VA_ARGS__)
> -#define ext4_msg(sb, level, fmt, ...) \
> - __ext4_msg(sb, level, fmt, ##__VA_ARGS__)
> +#define ext4_msg(sb, level, fmt, ...) \
> + __ext4_msg(sb, level fmt, ##__VA_ARGS__)
> #define dump_mmp_msg(sb, mmp, msg) \
> __dump_mmp_msg(sb, mmp, __func__, __LINE__, msg)
> #define ext4_grp_locked_error(sb, grp, ino, block, fmt, ...) \
> @@ -3401,8 +3401,8 @@ do { \
> } while (0)
> #define ext4_msg(sb, level, fmt, ...) \
> do { \
> - no_printk(fmt, ##__VA_ARGS__); \
> - __ext4_msg(sb, "", " "); \
> + no_printk(level fmt, ##__VA_ARGS__); \
> + __ext4_msg(sb, "" " "); \
> } while (0)
> #define dump_mmp_msg(sb, mmp, msg) \
> __dump_mmp_msg(sb, mmp, "", 0, "")
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded..72d6f6353a27 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -981,11 +981,11 @@ void __ext4_std_error(struct super_block *sb, =
const char *function,
> ext4_handle_error(sb, false, -errno, 0, 0, function, line);
> }
>=20
> -void __ext4_msg(struct super_block *sb,
> - const char *prefix, const char *fmt, ...)
> +void __ext4_msg(struct super_block *sb, const char *fmt, ...)
> {
> struct va_format vaf;
> va_list args;
> + int level;
>=20
> if (sb) {
> atomic_inc(&EXT4_SB(sb)->s_msg_count);
> @@ -995,12 +995,16 @@ void __ext4_msg(struct super_block *sb,
> }
>=20
> va_start(args, fmt);
> - vaf.fmt =3D fmt;
> +
> + level =3D printk_get_level(fmt);
> + vaf.fmt =3D printk_skip_level(fmt);
> vaf.va =3D &args;
> if (sb)
> - printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
> + printk("%c%cEXT4-fs (%s): %pV\n",
> +       KERN_SOH_ASCII, level, sb->s_id, &vaf);
> else
> - printk("%sEXT4-fs: %pV\n", prefix, &vaf);
> + printk("%c%cEXT4-fs: %pV\n",
> +       KERN_SOH_ASCII, level, &vaf);
> va_end(args);
> }
>=20


Cheers, Andreas





