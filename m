Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746478F2B
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459335; cv=none; b=GHoCXyucULnIxPLcOjXP3IRTwRro2a8Ovr8QYH8/jKN8P3J2PQR5oyWaiFpB+tei2Y1riABCbt2s7vtX7jmVmNSqNwmsA/E2u2b1L64MB/59lQcO6H+QhjVt0+oaf+Au01tTlZmQXVleGgR2C/WJIpRFOKVJuikRpj9wmFL2wzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459335; c=relaxed/simple;
	bh=2vCLg7vlSkFcVTt8svQc2STxgHJOQpU1COE8nq0Zgk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YpNsPtNgqG1hXdjSxwHtkzdbEBFBGzU1XpJ6T4V9dMv2ha2tOOrxItsXA+WwG6/EjUIbocD41bDT01zT2dF8QeyWcci9tyd0FzzJWnxb/RiwWGoPiy09zXYtaQXTl+sNx0VB0Tsc6nNmdeA9UXYQfH49be+Gk5CPQ58HVHXqsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKLNG+dw; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKLNG+dw"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f92e3c14bso275647f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459332; x=1786064132; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k+qwI01sjx4/0mGGehUG4DO+x7sR+uSFewjorP/zy5s=;
        b=FKLNG+dwhObsmMXnrSTP3g27wyACuvCgVD1sy9tqMcDeWFetn+ZfXwrss901n/cyEs
         tiksesYsLBFlzhLWF6bNpVJ9OOSMor+gCyKuvGqwJWISfbeXv5v3/gAHZcLyeKOHuKDq
         ErQ2WvGYDMoK5G5sxrIbzgkDC0jAYzqfRpOVSpw8EeUCp64+syeeA7E9uPq8PQoDWisg
         DrswYF1+AUCPviliUodNhO1+U6J01MUIgFZylqyh5lK+iliN73PhAYVt45EHNJIvbY0f
         Rz+rbA4CaPJk7KD6YlO+1ygX8NjbCj7Eg1NsSzAuU+p1picExKFGqzw92PZrt3ZQuPRm
         IkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459332; x=1786064132;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k+qwI01sjx4/0mGGehUG4DO+x7sR+uSFewjorP/zy5s=;
        b=rZd+ADPbYyH91tDnSiw2tPjdBgq/g57NlxtvWxS/sdlzNtNbKECxTrD08SWmtNpQyV
         Js4oi5/eSxJEe9+ruO6o1/YDmdNgczStIdiv5Ku0FZN1IOkDmbITIzfiEUQedDlhxHnD
         c+qA+Scvrwq2U87tvw7hlV4Tt9bfbMX2QH0JOCo6N8JJGBCmQoPSSlrTNvp5G/44YYEy
         yYx9cpTCRx/WxPardO3mvLk6fEcMz3sulhg0WPCpT7sXFKK6M3Ox+R1Kz31HGAyXGXaV
         Wh+zn8pAQCqI6v/FD9FiSTkKrtgE0cBhg3lU1XAAN/g8OJDsonOdMY2kN1lHtTg6Iqso
         GOSg==
X-Gm-Message-State: AOJu0Yyv3Zvp+mNiHkediKHAqovJKwswR7Igllq5PauFf5df9YGJqcbf
	EcTapzkOrMIbNDXajPS7y8rs+3r4n0bmsdOeEZE8NCzwQC2Bz6A9Phq8/upRXQ==
X-Gm-Gg: AR+sD129l3/+04bo4LgkzKDo5CG5qoY33M6V8x7zhz5PLq82qlqVAEnpEf5uOQdXZ7I
	ClU/3qCOVPZD+u9vF5wCl17bZNHXxMvi1JJvon5NVxZrhJyTKDRXZrOUW9iHLSaoV+11AcXZRlY
	cucz8O+NeNxfp1CuKXUu5rUpRK8Juii/AU3GtdtZ+HqCCGhfNxqTUQhtBbwRBbxmzvc+TkpP6aU
	N5in+vqgFW/TPx8l6r5EVNTRQfJ6G/ptGljCLi42QX0e4MNuyXH1IIsqOYOsVaHtpnGP3ovIF3N
	oEXwAJ5JPkeEDel6KeKz34v4hF6ya8E8k0FErIipNnZBIXOXWtQfPhwtspM5FUHW719S29BxOsu
	EQhSSgDTJ+BvoqCqfwtVRcNa5JOQZ23nhlT2JmGWOXx6UdGtVW/zhru9uNg054aJLNyPPDSSOKs
	pwKlkZeGkbhsLlyzVK150GfJu1G5mmRNO843DOgOs5Q+VWcIvHY9qccyBJVqSVW0b/oSUH+SFQP
	XGD4VQGz/bIJweTGM7b
X-Received: by 2002:a05:6000:4021:b0:47f:838c:4256 with SMTP id ffacd0b85a97d-47fd2adbd4fmr376235f8f.16.1785459331417;
        Thu, 30 Jul 2026 17:55:31 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v9 00/11] Data in direntry (dirdata) feature
Date: Thu, 30 Jul 2026 20:54:17 -0400
Message-ID: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EXT4 currently stores an 8-byte hash in the directory entry immediately
after the file name to support simultaneous fscrypt and casefold
functionality.

The dirdata feature provides a general mechanism to store multiple
metadata records in each directory entry after the NUL filename
terminator. The unused high 4 bits of 'file_type' indicate which
records are present; each record starts with a 1-byte length field,
providing forward compatibility.

The first user of this feature is LUFID (Locally Unique File ID), an
identifier that must survive rename and be accessible from directory
readdir without an inode lookup.

e2fsprogs support is provided in a separate patch series.

Thanks to Sashiko AI review for identifying several correctness and
safety issues in earlier versions of this series.

Changes in v9:

Patch 05 (dirdata format definitions): remove unused ext4_dirdata_next()
helper. It was added alongside ext4_dirent_get_data_len() but never
called; the loop in ext4_dirent_get_data_len() advances the pointer
directly. Dead code that reads a disk field without READ_ONCE() is a
latent TOCTOU hazard.

Patch 08 (dirdata feature): fix ext4_readdir() to use ext4_dirdata_get()
instead of the fixed-offset EXT4_DIRENT_HASH() macro when reading the
casefold hash on a dirdata-enabled filesystem. The fixed-offset macro
reads LUFID bytes as hash data on entries that carry a LUFID extension
before CFHASH.

Patch 08 (dirdata feature): fix get_dx_countlimit() to decode rec_len
via ext4_rec_len_from_disk() before comparing it against the blocksize.
The v8 code compared the encoded on-disk value directly, which can
differ from the actual byte length on filesystems with large block sizes.

Patch 09 (LUFID rename support): revise the size-mismatch handling in
ext4_setent(). The v8 approach — leaving LUFID bytes and flags in place
— preserved the CFHASH offset but kept the entry advertising a stale
LUFID from the old inode, and also left the CFHASH unreachable when
there was no subsequent SET_LUFID call. The v9 approach introduces
ext4_setent_compact_exts(), which slides the CFHASH bytes into the slot
vacated by LUFID and then clears the LUFID flag. If extension headers
are malformed, CFHASH is cleared instead of risking a corrupt read.
Apply the same fix to the no-src-fid clearing path, which had the same
CFHASH-stranding bug when renaming a non-LUFID file over a LUFID+CFHASH
entry.

Patch 10 (dirdata set/get helpers): fix ext4_match() to pass buf_size
(the inline directory buffer size) to ext4_dirdata_get() instead of
sizeof(struct ext4_dir_entry_2). The old value was too small for any
entry with a non-empty name, causing ext4_dirent_get_data_len() to
reject every extension as out-of-bounds and always fall through to the
legacy fixed-offset hash path, silently missing LUFID entries.

Patch 11 (SET_LUFID ioctl): fix dx_get_dx_info() bounds check for the
'..' entry. Replace the absolute rlen > blocksize check with a
position-relative check, (de_buf - base) + rlen > blocksize. The
absolute check failed to catch a '..' entry whose rec_len would extend
past the end of the block given its actual position within the block.

Patch 11 (SET_LUFID ioctl): add IS_IMMUTABLE / IS_APPEND checks on the
target inode in ext4_ioctl_set_lufid(). The v8 code relied on
inode_permission() alone, which does not cover those VFS flags.


Artem Blagodarenko (11):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add dirdata format definitions and access helpers
  ext4: add ext4_dir_entry_len()
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata LUFID support for directory entry rename
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 fs/ext4/dir.c             |   49 +-
 fs/ext4/ext4.h            |  230 ++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   67 ++-
 fs/ext4/ioctl.c           |   85 +++
 fs/ext4/namei.c           | 1187 +++++++++++++++++++++++++++++++------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1392 insertions(+), 244 deletions(-)

-- 
2.43.7

