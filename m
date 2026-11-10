Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794285719;
	b=K/RyumEPMQnZsSVr356VyO8ymoQzffXM0p9juvRzMvlCIAstCEFU41cq7xc7uCPngY8U
	 fpTx4O0mtNzEdGsNbicnOTA0kRSYwc85PFGZHkVqFRQf4o9+Q73ZpjaB9/MHvBkHsESQQ
	 2+AxlidAqHqcmvBZzk4r3zRbIa1NwAaI2KAMFjBCI6V/kSkKo7v46ej97UyTsXjkxw8SW
	 t7VZrXmVY91k0+kf6ysU5MQhOz5kmndonyMWytDH5Kgf6IAu8OvFenqwSfnSbPN2WxxDS
	 RmkYfaoi5YlkJ9JLA18sUt9VeiRu1zrHQyNN10L7fIf15KToTB2HOlSKx2Bs9gsDHQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794285719;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:Date:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=YLK5mI2HZycNCt7rWXOxxTr/V6sJotmzO0iIyiajJns=;
	b=5kflr8i8Q2V/OsyUhK7mpEKBZnudjOcz8xYf1LBk+D9Bp9rlkrnYHbcrqOXtYBeVICrg
	 XSq/TzJqQw+YSynbGsK880ZStFOiOr70zBBrrlabyjTpPCSj1Q11UgRLD2nhDer5FO9Rt
	 RE/VM0BCg/H7RlKTJUujWwu+Szc0ggSV6881vg/Ee1VieuLFaK+gbF1CeF13K3NemkKd7
	 hMCFqeDqjqb0KMPOEI0CwVWTHpO59UDcnmrJwQcEyemMltfN2h25c3xhhUzLzqxEadp9l
	 1kU1cL11QR9/mxjqJ6jnTHWo0VHmG7DYt6wvSE/Svm87wWAsbHnV4L7u8Ic3a4GLNww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="w/dHZ3Xl";
	arc=none smtp.remote-ip=203.205.221.164
Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34E6606A31C;
	Tue, 10 Nov 2026 04:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B34E6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=w/dHZ3Xl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794285708; bh=YLK5mI2HZycNCt7rWXOxxTr/V6sJotmzO0iIyiajJns=;
	h=From:To:Cc:Subject:Date;
	b=w/dHZ3XlgRAHpBXE9zDSwqcT5okc/2Er95os8cz1NjjHwnMl/jt8U7bCNWdpnqsa+
	 sr3r+DlpaytzwHydm2wmagXK+oA+SD6okrh+JDRJ6xcBH7CAnQP5BzNiyPwOCRtinV
	 zXQtDHyqHJ1yfc9JUaWN25jRDXpCxtaczurStP94=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id A6E0DCFF; Tue, 10 Nov 2026 12:41:46 +0800
X-QQ-mid: xmsmtpt1794285706tdgv82nho
Message-ID: <tencent_B079992E4541FB5447D9A4067D6F8D40380A@qq.com>
X-QQ-XMAILINFO: Nd44/NwdEDGNCRXJWmaAImJ1WaHgNzn0zQTgN4YTy6Ac1myxw9oGBE7VHBTrHd
	 YPJTWXs5eH1kPzdXgSj53VDoNsy5tn6ka8taauu9xWjA5de0FzG60CmIF/UxEbYyImV0y2Ak2qXk
	 1gv+J9XFV3UwWZk+FnvCL+N/tJEwebWG64VAGK5xua/XHm+Xn7w83aT6EhfxoNoAP2RdzKwqb7XI
	 EEsCk7tcEBatHvRIksVng2KPdO7mQi8fzswabQpM65TxYxlfjOXDgJyk048+VR8j1sG0Ko3lK9QL
	 PN5s/ZndFpUNDV4JXcd6rrCrdjCJRifEkU3YESb/Uiqnqzm5a50sOThDzDKPMDfA4uFxyxSqtncx
	 pmN79LuQE1GpFSmGSKsRCZU2meSbQvVPNkvnTWM5W5z980VSkalIKNbH80ZfAL43JaufvRv+P+8K
	 868Dn2pr4CpO87lNEbxPmP8onMOyihKjCgF4BZlP+Spt8nMTPon1dJDD5v7Y/7RwYasYnkUH/nor
	 oJpE/WGDA8+bLSXQRuQGOmm2bKvh+t4CtkKpv3qoHqAycOuGh299sfyN9KSL61FabuT8K8dEKbe1
	 NhIGuPJGc8scmGgDiVhVrGv8BOdC3DOCLRXeo5D1KHnK3Gugtc7EpF6OJEFflwaAJAa236Vu66uj
	 Eql+1jW/xARHDBL4O+xGD+MJN1oEWvskOENXGS367rUNqp35PsG7wCMoX58SeCvVl15vFzUbmjc1
	 g1wTVkjhTBzxyHeZ7zRD1dWy9yzpp8uvWCZDuUNwFsULp9YkPf9GYM1YpTYLvqzQr1I/EbxkELtN
	 gX7O4PYJ65swYDHF188H7dRPh4Tku2z0PZ0f7wWosk1899a6xptiQwDC0+tuM/l8NR5MsnDW3UN4
	 X6Gd96m/UPaxSxliOd7+etbtbqsNNcDUPSfQgSrRBJO5/Iki2Vd+Ewpdh1dyCpoJhSWLogGuud7D
	 R8w2drNwoQNP0V4PDSu4QabaIT7V7MX5uw0uxnpb7Tdu455L3zNsKKDp2iQ7bcFCASZD4BH63ZVc
	 QHmLbF1U0Ljx+bbrvS8SAv+2b8M/qtJv83JIvSzowwQ4Ddh9GtykQW4tF+9jQ=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Guikun Yang <yangguikun19@qq.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: [Bug report] ext4: enabling casefold online leaves s_encoding unset -
 null-ptr-deref in utf8nlookup()
X-OQ-MSGID: <c43-ext4-online-casefold-null-20261110@qq.com>
Date: Tue, 10 Nov 2026 23:50:00 +0800
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

EXT4_IOC_SET_TUNE_SB_PARAM can enable the casefold feature on a live
filesystem, but nothing rebuilds the runtime state that the feature
depends on. A lookup in an already casefolded directory then
dereferences a NULL unicode map.

## The gap

The ioctl allows CASEFOLD to be set online (fs/ext4/ioctl.c):

  #define EXT4_TUNE_SET_INCOMPAT_SUPP \
          (EXT4_FEATURE_INCOMPAT_EXTENTS | ... | \
           EXT4_FEATURE_INCOMPAT_CASEFOLD)

and the callback only writes it into the in-core superblock copy
(ext4_sb_setparams(), fs/ext4/ioctl.c):

  if (params->set_flags & EXT4_TUNE_FL_ENCODING)
          es->s_encoding = cpu_to_le16(params->encoding);
  ...
  if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
          es->s_feature_incompat |=
                  cpu_to_le32(params->set_feature_incompat_mask);
          ...
  }

es is sbi->s_es, so ext4_has_feature_casefold(sb) becomes true
immediately. sb->s_encoding, however, is only ever assigned in
ext4_encoding_init(), whose single call site in the tree is the mount
path (super.c:5468). The ioctl does not call it, and nothing else does
either.

After that, the inode-level check in ext4_iget() no longer rejects a
casefolded directory, the inode gets S_CASEFOLD, and a lookup in it
reaches

  utf8_casefold(dir->i_sb->s_encoding, ...)

with a NULL map, i.e. the same null-ptr-deref in utf8nlookup() as
reported previously:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  RIP: 0010:utf8nlookup+0x38/0x890
   utf8byte -> utf8_casefold -> ext4_fname_setup_ci_filename
   -> ext4_fname_prepare_lookup -> ext4_lookup

## Why this path is not covered by the earlier fix

The same crash was reported by syzbot in 2023 (9cf75dc5) and was closed
by 6f861765464f ("fs: Block writes to mounted block devices"), with the
comment that this series would "ultimately be the fix for this class of
issue". That fix blocks user writes to the page cache of a mounted
device. This ioctl does not write through that path - the kernel itself
changes the feature bits, inside the fs code, with the write protection
in place. (Journal replay reaches the same state and is reported
separately as <c15-ext4-replay-casefold-null-20261103@qq.com>.)

The removal of the NULL checks in b81427939590 ("ext4: remove redundant
checks of s_encoding") rests on the invariant that the feature bit and
sb->s_encoding are always consistent. This path is one that breaks that
invariant.

## Reproducer

Needs CAP_SYS_ADMIN, but no crafted image:

1. mount a filesystem whose superblock does not have the casefold
   feature, containing a directory whose inode carries EXT4_CASEFOLD_FL
2. GET_TUNE_SB_PARAM to read the current feature set
3. set EXT4_FEATURE_INCOMPAT_CASEFOLD in that set and SET_TUNE_SB_PARAM
4. lookup an entry in the directory

Two things to know about building it:

- set_feature_*_mask in the SET request is the complete target set, not
  a delta; sending only the new bit makes clear_feature_*_mask clear
  everything else and the call fails with -EOPNOTSUPP. Read the set
  first, then OR in the bit.
- the ioctl writes the feature into the superblock, so the second mount
  of the same image initialises the encoding normally and does not
  crash. Each run needs a fresh copy of the image.

Deterministic 3/3; a control run with the ioctl skipped mounts and reads
the directory without any report. The reproducer is available on
request.

## Suggested fix

Either rebuild the runtime state when the feature is enabled online
(call the encoding setup after a successful feature change, and handle
failure by rolling the superblock back), or restore a NULL check on the
namei side so a casefolded inode with no encoding fails cleanly instead
of dereferencing a NULL map. The first is the general fix; the second
also covers the journal replay path.

Thanks,
Guikun Yang

