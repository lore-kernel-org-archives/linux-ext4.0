Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245175;
	b=Y2/ZPDbzCjLfPcFxpBTBtcBt0VIUzGUYHT7i+lOCWaqo1RmKIvDXCAcfEW2SxEfGl9un
	 gVigy7ChnIGbWfof1GVkCqGiEuEAh4BieggmyCF8GKjzC29HYBfhb0cGHhkf2E/WEy2oX
	 Qg/JL7/PIytAtgNJIKIImuQGLKBSJmSKKPWVwoedMXyUGoOjqbvENwpAdiXTwGO5X8xVs
	 e0SFYaPkZam2/lOWQrVopcVyb+Yg3BJWEOw7PrCH1JYVtG2HUeL4JDNhzxusAx3svQc+d
	 WXwE154T3wSDYWgmgMhMiQo5wwPw7pe7ryL2ytEM4WQOUWN1SpOIalwPGLks+IyPPYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245175;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:Date:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=ReT/huRCwfMeZEY0msKfX5bV9rfXIpPsvnOvO19k0iM=;
	b=GdMqIuEyM6WGb8DNDA/4q73GV1/ofmy5cLQPUZ2qDP0+e7LEHIYp721mJQXE+jrfENhi
	 ci7Ok7atcNb1Sg5Bam1wC32imyMI4kcs5qPFyvdgJ8GBbOSylhAd/UOo6BZlmU2nt5Key
	 Gs3qQl8AmneG1dJGIWyCvrXfQG+7qDN1vLB/ov+XIDlO02PovqEinDybfCnUcjvgzeRIv
	 9byNuIjl9QWJWqUmkcFzizu256ZWE5xOpXUjq0o+W4MBYg511QoyqP+zEhlDZqPlvFLdQ
	 XiLzflDaPjvzXVuHXgwmxq4lO8ZLA2wWSEvaiOYv4SuuRn+B+tKhODE+SD0vfES/VEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=B+G+nXic;
	arc=none smtp.remote-ip=162.62.58.211
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240DC606A31C;
	Mon,  9 Nov 2026 17:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 240DC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=B+G+nXic
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794245163; bh=ReT/huRCwfMeZEY0msKfX5bV9rfXIpPsvnOvO19k0iM=;
	h=From:To:Cc:Subject:Date;
	b=B+G+nXicFPHm3mw6u6BHvH7g3mK+V9b/Oan/hAEe8OdWIH2zOmTtWQMjCHq/wux6B
	 aFUrpsZdhfvMMIZgP0UkQ4cieQVwvBAUMAOQfuxTbA4KvzfLOwgqwYP0zjq7oRXuVX
	 fs1OLUn6r84StJ68fHSlG0PIhGVm3Iy+QTwkw83Q=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 68090602; Tue, 10 Nov 2026 01:26:00 +0800
X-QQ-mid: xmsmtpt1794245160tqflx7u6g
Message-ID: <tencent_4F47889D184C7FA2287DC2A33A52F3BE9F09@qq.com>
X-QQ-XMAILINFO: OOO9dHjlsLs72kQUanzLSruAXh2zhKkMYlb2d5aU3n1X7udd1vcg97BC2QHnHT
	 GK8X8FLwMTT2hmi8N7eKdKaB2ygZ0mPPGUMniCWSBJ73laBK1AFeXVSWtxWDhXKL6NjcCIsPT9QK
	 yoIaehq1q0W0t103MepaJFLozK1TnY248VvrdkDgJrcSS74v6I2pCj1H0eumWDAfedhtM3uBJaRs
	 osIQ8MtfRdq4b3Nq8GALMyGjnZVK6clgZrA+/D6zGPTHdSEciWxO+65nH1y97OPrnLNurJlYz5RR
	 i2zlAj5qVobHXCOu+KuZKVnumUV1X0jQ+YZMSKE1zCZ2cGj8ff8wBsLUbBGKG5Lkb2KB9t89PpJf
	 B1BGCWFLrYzAGbyB29aqBLC4b3XNr9hBIeO9gFyfhParD+2IImy2UniZ+SHM48uhkwRbeOfX/28V
	 /ke/33bknqQ0HC5WblMk9WfMq+1c9myhmCQII1lGD5TurDIH48w1WquPqXZfKkAHtQfqdULnTzWM
	 YSYumMTzhaOQmwADJmYlTbesl1Ol+XYvFetca1SDi5d3PZPsfddocA+rcJuYXDR5aoSlfcPCbsMN
	 oJBz5+IIap2cRsyecUySS0xl3OU/ou8YsBeohHjMwPSV1u0uLJOHf/mr/fPVUlN3HdLI19ls+ib4
	 LwvS7SHKNK3RgVuDEMOBUD8zGLVKTqXFev8UnX6koosFLASgY2lu+ejrfpIBzGu/qFKZGhiFTL3q
	 GQWJe+nezrlulmxA2Gt+eqz/3XQr9NuDzDnNfrED0QpK32ahiyGC21te1aqwwIYyU/uL9BiE0TZ7
	 NM+Pn5Z+mDp7ZwUu6Yhw9JjS/xC1fn0fgOx3fEIQCl+fy8zrangFzguNn0rUS3pNaH3D9spGzS/T
	 9hLOqlkUFfBkA1lrtBGBcOddy7o9nZ416BDHO8Aw1sXNWUMKA4QqOhJkwFs2RBxur/tRi8BkcGho
	 YTnpais7X6jCbldURBEDdzCHPSLB1pbGhwyp9ERevJXDPzTBgFzitg7IcvZRP1CfTlRm+LouOJWo
	 CKlfnmThoa3onk3pIqmatxADr3noLlInDla7ukV2ljh9zT3uDI
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Guikun Yang <yangguikun19@qq.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: [Bug report] ext4: unvalidated hash trailer read past a fake dirent
 in ext4_inlinedir_to_tree()
X-OQ-MSGID: <c42-ext4-inlinedir-hash-20261110@qq.com>
Date: Tue, 10 Nov 2026 18:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

Reading a crafted inline directory ends in a KASAN slab-out-of-bounds in
ext4_inlinedir_to_tree(), reachable from getdents64() on a mounted image:

  BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xb6c/0xc00
  Read of size 4 at addr ffff8880052496bc by task init/1
   ext4_inlinedir_to_tree
   ext4_htree_fill_tree
   ext4_dx_readdir
   ext4_readdir
   __se_sys_getdents64

The address is at offset 0x3c of a kmalloc(60) object, i.e. exactly at
the end of the buffer that holds the inline directory payload.

## The gap

For a casefolded and encrypted directory, the dirent hash trailer lives
right after the name, at an offset derived from name_len alone:

  #define EXT4_DIRENT_HASHES(entry) \
        ((struct ext4_dir_entry_hash *)(((void *)(entry)) + \
         ((8 + (entry)->name_len + EXT4_DIR_ROUND) & ~EXT4_DIR_ROUND)))

__ext4_check_dir_entry() decides whether an entry is "fake" first:

  static bool is_fake_dir_entry(struct ext4_dir_entry_2 *de)
  {
          ...
          if (de->file_type == EXT4_FT_DIR_CSUM)
                  return true;
          return false;
  }

and then validates rec_len against the fake variant of the length
helper, which does not account for the 8-byte trailer:

  else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
                                          fake ? NULL : dir)))
          error_msg = "rec_len is too small for name_len";

With file_type == 0xDE, a 12-byte entry (name_len <= 4, no trailer)
passes every check, including landing exactly at inline_size. The
readdir path then reads the trailer unconditionally:

  if (ext4_hash_in_dirent(dir)) {
          hinfo->hash = EXT4_DIRENT_HASH(de);
          hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
  }

EXT4_DIRENT_HASH(de) evaluates to de + 12 for such an entry, so the
read starts at the end of the dir_buf allocation.

Reaching this requires ext4_hash_in_dirent(), i.e. S_CASEFOLD and
S_ENCRYPTED on the directory inode. Both come from the on-disk i_flags
and are set unconditionally in ext4_set_inode_flags(); no key is
needed, because fscrypt_get_encryption_info() is called with
allow_unsupported from fscrypt_prepare_readdir() and returns 0 both for
an unreadable "c" xattr (-ERANGE) and for a missing key. The only
build-time requirement is CONFIG_FS_ENCRYPTION, which distribution
kernels enable.

## Observed

Deterministic 3/3 on a QEMU x86_64 kernel with KASAN and
CONFIG_FS_ENCRYPTION. The image is a normal inline directory whose
inode carries CASEFOLD and ENCRYPT, with the last dirent given
file_type 0xDE and a rec_len that leaves it flush against the end of
the inline payload (inline_size 60, hence kmalloc(60)). The control
image with i_flags cleared mounts and reads back the same directory
without any report.

## Relation to the lookup-side fix

This is the same read that c7e6b863d298 ("ext4: check dir entry fits
before reading the hash trailer in ext4_search_dir()") closed on the
lookup path:

  if (de->name + de->name_len <= dlimit &&
      (!ext4_hash_in_dirent(dir) ||
       (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
      ext4_match(dir, fname, de))

The readdir path never got the equivalent check, and its leniency about
fake entries makes the gap larger: it accepts a rec_len that excludes
the trailer entirely. The neighbouring inline read path also gained two
header-length checks in 9333cc809f ("ext4: fix out-of-bounds read in
ext4_read_inline_dir()"); ext4_inlinedir_to_tree() has neither.

## Suggested fix

Skip entries whose rec_len cannot hold the trailer, mirroring the
lookup-side condition:

  if (ext4_hash_in_dirent(dir)) {
+         if (ext4_dir_rec_len(de->name_len, dir) >
+             ext4_rec_len_from_disk(de->rec_len, inline_size))
+                 goto out;
          hinfo->hash = EXT4_DIRENT_HASH(de);
          hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
  }

The same condition applies to any other site that reads the trailer
without a length check; this report covers the one we reproduce.

The reproducer (image builder, ready-made image, serial log) is
available on request.

Tested on 7.3.0; fs/ext4/inline.c is unchanged in mainline as of
2026-11-10 apart from the two fixes mentioned above.

Thanks,
Guikun Yang

