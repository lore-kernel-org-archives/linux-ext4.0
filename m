Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794703401;
	b=YuYfgeGHOxDc3aLI2rMTfVGx9c3pJQq+I3h1B2Be1mWzL9N37hW8L1ur714vgIYU+cCC
	 uOrW8kDrENdHaWQrwF5PfvsFkERlkWAuyAxmkQMX3LXj2QGENDR5URllRPT8uOXGcX4LX
	 SaAAyVPgV9VCFdSZx0R8uKxhlXw7PZlo1YFD5rCops9qR4GDO2wEGXB6PoY4gJiovy1Oa
	 zwug7FoxIvwpFNoiPuZ0Ax53ePTq/gVun3xOHsa3D/MkGiWJvmD/KONOrEUB0m7RbndEU
	 DAToPjsRD2T8fo/GK3GDPA3VraaTY8tu5zmTEsPZE6FJoVjDonVnyM0ZlSSD9RCltFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794703401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=8MMIuK6I3K5vQ1yQIxsPt4KprzePyt/7G+X2OrZOpnQ=;
	b=CNKgSyjNSLsPWRma1URYcjenfZdOHh6toI3oZbdjqrFB6YZ3unPCjb/XoE88vrfo6LyX
	 oJ6GUkltKw0+5VpS1o0bNMT5f6pF4LidNCagX6DVEJtCTJYjBO1F84e9SZsRY8kVgYiaM
	 vNNZyEcnpykIHzv54cyyATz6gisGbJga0SuOMsCkBHYywrKdFunJTosJEdNGsMwWYlx1+
	 qOuP8VyjJBE5IBN4dlDyAJQN7pQKF2Kd7erZU61lJ6vt1PfSHHFTp3RV4YtVe+k4CvEaA
	 9aLzuIET/koPSi1CjlqUgFABrAvtFIkFeCil+hQoR5GMaA91HIGI65kqUfqU7kCxQUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GBanHfsv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.174
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748B9606A32C
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 00:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 748B9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GBanHfsv
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3ab30b3212aso23070471fa.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 16:43:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794703399; cv=none;
        d=google.com; s=arc-20260327;
        b=Cx4fw35t8pQ4RD/05AEulMtsN3/pGiIRQlLDZgYTNyN6Px/MpU0v/WILcmT8gmIOwG
         agya//SPL+7yejdkAqLrvs5SPs+BZj3JbV0nsQoZI0NZZ6BYaHH2ziNKTk3TrKmpr1dP
         vGDOeJI6pEVCd20G7OCzqSTyA0e1oNQTgdNIB60z5cSGkaRgi3D2O4Y8mlKgxszCWl3g
         Ih0iC8Q88my2hkqFDcl4LViTbXwhsztENIdX4QJVRxSXVl73xSOFSTwrO1pcKrRmgFBO
         Bz4EvhxzGDt3GioGXC1V8cKuxiR+PyftIx92fIxBAEQqZ3AWkKsDa8CmCEdmzmqmQrV+
         LMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=8MMIuK6I3K5vQ1yQIxsPt4KprzePyt/7G+X2OrZOpnQ=;
        fh=UA9O/O6ki/m1asr+3s6igaa+spoJcs68PXPJboluwvI=;
        b=eoNmYNlkag3NBM9Le+ZPUFafYr9rGCMNiS0Fb+kHLNFyBctH5Oltg6RCV6wgr8n+X2
         a22rPFgrR/udKiAvVW48j+WOmhL6C8M4xr1QGHL542y2Bof2gDnagl3YaJeo8cjSxdLS
         PjszU3YQ5lXSsom88ff7zXTGGHAXnBETytI/H2gClyk34cB+ZyNFPs1PjhkGHSEHLo8B
         FVp60jzkf0ADCpCbGK1IslMWsa0seR0642qsyemeM+Ag4jLgpRepfz0OL1XZXbSze3Og
         Lk/NyDuiOsuDOFzLs58pczV7nWEm00qWIKPvs81xzNUtJeUedtiCb3wqxgBLMZLJ6ibV
         ygCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794703399; x=1795308199; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8MMIuK6I3K5vQ1yQIxsPt4KprzePyt/7G+X2OrZOpnQ=;
        b=GBanHfsvXOqB75slLJE8LsLWchFvISNyGuo4w7xvL7rAq1Lfb/YkB+j77Xmizbu41Q
         NFremmdoli7wbpdX7104B5dQ9vCEaZwX1+oJmpB6en+RDNoaZx7tgHVK664nesAsBeT/
         FE8GIzicPL0PeDBaCruCxHJmoWk4hTkQ/0AnUkY9mB3VR3EzWXHVLgDX+NdTsNcgpIJp
         xNTXUzk6t4/rvSN+jtY19v4CUMy/x+wGLSv/o+DWGR19PYu6P5pm9s789Fu/s43dDoKU
         Vt8ARK/d7emk5S8hRilnLidFiXt9mx/f17g+2XrqS0bWoBWKSnN3LjqXAE2HKo+cgC59
         BIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794703399; x=1795308199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8MMIuK6I3K5vQ1yQIxsPt4KprzePyt/7G+X2OrZOpnQ=;
        b=Ji2pBAY5DcuiGJ+Qh9kdEJ7WMTPXOKzbUo/iPHYvFV4KhwWDh2Mg+I0eN3e9GTTpVL
         Y/cf+8xOeNPhi4iWNcJudzFblKqOLoyskWFJk59Zy7w1nkJWIfrHRMI49XNXKDGN7BDu
         GBKawnPYVmFjESCLzXMIasLa81IQ4SVFQQt0S/JIK/5jaDdlKy+rJum3aqGUsAZluUs4
         ypFG7g5T1cogklAlFiJZkfCfK+F/GrEHXEUKE98idArxtHG+OjCL11QLLtjhKPgX1Ojy
         +rv0v+6/rUjJ5JxlQraPJb7FPTGhZb9Ag8Bnd7OnNPXV+CRYkIn+FThKjVxnygJp1CXz
         j+dw==
X-Gm-Message-State: APuU4Z+Aw7FL5sPfqfxFNUdJ7gfouiJHOfUsA7AZP6A1gyGcL0AwnTU1
	gFZiSqb4u6g9qDVBh1lgr3DrrYTI4sgACT2jipf9crenexC7+0ZbldahRMfCaGTMmYMk2faxPQ0
	zLaf6C1X0cXr7tpljP3CcqtOSbrKBNFo=
X-Gm-Gg: AYBFou3EV2rlUjjPO4Idyf1lQqsPE9SrcBVdCUhKB5Xn2bYZSBPPEJFqS+2Dnm9A8Nh
	djWGPlMLLJ2tVeC4YlidQ73OPXx+sG/tHvwMHie6kSKZ0K4jZ0jOYn3TiEXqj7yqOTNoY+2EzQl
	Ihn69PPXJ44gyYgCbnHbbJHurIXTkoOD3NJ/07x+l7mSags9GtTP0DmExrCWpnCw7V+rx4hdgcG
	TuHBq1Nd0WQMc2T+JvTm/oyafISqBhDbUcIgrKXzsxoRu0Dgg1nASsPp2Q5dr1cDZk0o4jEwSl0
	eXEgSLYAMI0agOYJtoeq8PRom+nT6sNwGvZ7AsLs6+shUlPf8LpgZaarIwVbWTjkULF6izNmo9w
	+tsg2uKyMxf1EFDsZGldCfYB6Pt94Lf1hJ0MTwadrJ2fqfqGtVmsfC5obAA1leu00lK03+iVJN6
	F+OCeijTk/Ys45H5MsFYJF8bFlM1zvDj9VUIwQ+xbqhrNTyZrLrywbdUwKYhFc0fHBkey6LlYle
	spI8Q==
X-Received: by 2002:a05:651c:1544:b0:3a8:380c:9fb6 with SMTP id
 38308e7fff4ca-3ae2b6aaccemr21264111fa.28.1794703399262; Sat, 14 Nov 2026
 16:43:19 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Ahmed Khan <ahmadpsn95@gmail.com>
Date: Sat, 14 Nov 2026 19:43:08 -0500
X-Gm-Features: AclHuK8JguVcAUUYQrhGxKWIahEIGkCO11fvzc8h0VRZO67ypHW-NhqDoZkf2P0
Message-ID: <CAOaS1==g3mdoqmS2AjOC0_-woXJbA_X0LJQt7+M7d1=+gfyQqw@mail.gmail.com>
Subject: [BUG] ext4: NULL pointer dereference in jbd2_journal_file_inode()
 during inline data conversion
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Theodore and Andreas,

My name is Ahmed Khan, I am a security researcher from Canada. I
believe I found a bug within the Linux Kernel, specifically, version
7.3.4 affecting all major distros. I will be candid and state that I
used AI heavily in fuzzing the kernel using "syzkaller". Below are its
findings, the proof of concept worked on my QEMU VM repeatedly.

I found and verified a deterministic NULL pointer dereference in
jbd2_journal_file_inode() triggered when expanding an inline_data ext4
file via path-based truncate() on a filesystem mounted in data=3Dordered
mode.

This corresponds to syzbot crash ID:
3eb9083d961b1b97587d103692546ba06797de4e

1. Root Cause Analysis
----------------------
In ext4, EXT4_I(inode)->jinode is lazily allocated via
ext4_inode_attach_jinode(). Normally this occurs during
ext4_file_open(), ext4_write_begin(), or late inside ext4_setattr().

When path-based truncate() is called on a file without opening a file
descriptor, the inode enters ext4_setattr() with EXT4_I(inode)->jinode
still NULL:

  /* fs/ext4/inode.c =E2=80=94 ext4_setattr() */
  if (ext4_has_inline_data(inode) &&
      attr->ia_size > EXT4_I(inode)->i_inline_size) {
      error =3D ext4_convert_inline_data(inode); /* jinode is still NULL */
      if (error)
          goto err_out;
  }
  ...
  /* ext4_inode_attach_jinode() is only called later in ext4_setattr() */

During inline conversion, ext4_convert_inline_data_nolock() calls
ext4_map_blocks(..., EXT4_GET_BLOCKS_CREATE). When the inode also has
EXT4_INODE_EXTENTS set and the filesystem is mounted with data=3Dordered,
ext4_map_blocks() calls ext4_jbd2_inode_add_write(), passing
EXT4_I(inode)->jinode (NULL) directly to jbd2_journal_file_inode().

jbd2_journal_file_inode() then acquires journal->j_list_lock (with IRQs
disabled) and dereferences the NULL jinode pointer at offset 0x28/0x38,
causing a fatal Oops/GPF while holding the journal list lock.

2. Reproduction Steps
---------------------
1. Mount a crafted ext4 image in default data=3Dordered mode containing a
   regular file with both EXT4_INLINE_DATA_FL and EXT4_EXTENTS_FL set.
2. Without opening a file descriptor on the target file, invoke:
   truncate("./file3", 0x10001);

 * Proof of Concept: Linux Kernel ext4/jbd2 NULL Pointer Dereference
 *
 * Target Linux Kernel Versions:
 *   - Upstream Linux: 7.0 =E2=80=93 7.3.4+
 *   - Confirmed Distro Kernels (6/6 Tested Distros Crashed):
 *       * Ubuntu 26.04.1 LTS (Linux 7.0.0-38-generic #38-Ubuntu)
 *       * Ubuntu 26.10       (Linux 7.3.0-10-generic #10-Ubuntu)
 *       * Fedora Cloud 45    (Linux 7.2.11-300.fc45.x86_64)
 *       * Debian Sid / Forky (Linux 7.2.15+deb14-cloud-amd64)
 *       * Arch Linux         (Linux 7.2.11-arch1-1)
 *       * openSUSE Tumbleweed (Linux 7.3.3-1-default)
 *       * Upstream Base / CachyOS (Linux 7.3.4 SMP KASAN)
 *
 * Vulnerability Summary:
 *   Triggered via truncate("./file3", 0x10001) on a crafted ext4 filesyste=
m
 *   where the target inode has both EXT4_INLINE_DATA_FL and
EXT4_EXTENTS_FL set.
 *   ext4_setattr() calls ext4_convert_inline_data() before attaching a jin=
ode,
 *   causing ext4_jbd2_inode_add_write() to pass jinode =3D=3D NULL into
 *   jbd2_journal_file_inode(), causing an immediate NULL pointer
dereference (GPF)
 *   while holding journal->j_list_lock with interrupts disabled.
 *
 * Crash Signature:
 *   Oops: general protection fault, address: 0x0000000000000028 (or 0x38)
 *   RIP: 0010:jbd2_journal_file_inode+0x14b/0x5b0
 *   note: poc1 exited with irqs disabled / preempt_count 1
 *
 * Compilation:
 *   gcc -O2 -o poc1 poc1_ext4_jbd2_nullderef.c
 *   Prerequisite: ensure /dev/loop0 exists (modprobe loop && losetup -f)
 *
 * Originally autogenerated by syzkaller (https://github.com/google/syzkall=
er)

3. Crash Log (KASAN)
--------------------
[   18.161021] Oops: general protection fault, probably for
non-canonical address
  0xdffffc0000000005: 0000 [#1] SMP KASAN NOPTI
[   18.162724] RIP: 0010:jbd2_journal_file_inode+0x14b/0x5b0
[   18.163481] Code: 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 4a
41 8c ff 49 8b 44 24 28 ...
[   18.170125] Call Trace:
[   18.170410]  <TASK>
[   18.170685]  ext4_jbd2_inode_add_write+0x138/0x1e0
[   18.171220]  ext4_map_blocks+0x1102/0x1b40
[   18.171691]  ext4_convert_inline_data_nolock+0x18e/0x450
[   18.172281]  ext4_convert_inline_data+0x17c/0x250
[   18.172780]  ext4_setattr+0xa2c/0x1ea0
[   18.173200]  notify_change+0x628/0xd60
[   18.173620]  do_truncate+0x144/0x230
[   18.174020]  do_sys_truncate+0x17e/0x200
[   18.174450]  ksys_truncate+0x2c/0x40
[   18.174820]  do_syscall_64+0x10e/0x5e0
[   18.176450]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   18.178920] note: poc1[318] exited with irqs disabled / preempt_count

4. Suggested Fix Direction
--------------------------
Calling ext4_inode_attach_jinode(inode) inside ext4_convert_inline_data()
(or prior to calling ext4_convert_inline_data() in ext4_setattr())
ensures jinode is allocated before ext4_map_blocks() attempts to add
the inode to the journal's ordered data list.

Please let me know if you would like the standalone C reproducer or
the minimal ext4 disk image attached inline. I have this in a private
repo and would be happy to add you as a project contributor.

Best regards,
Ahmed Khan
