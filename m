Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313594E73DD
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658382; cv=none; b=WfVzOXBVoqEXk579WgbvZ9G7eUMIhbSsPLhI32rFkCT5aBfui8bavEO/S8ynIfqXvzY78Qpdi2yJqLLu3NBtzd/F9UGnyIligDiBIQesHWRZx7bYI0c4UuFh3qJhgbqAwDtw+c37Bh7berxNkFkcZjm80w7AC45WWRPAjp37UuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658382; c=relaxed/simple;
	bh=t6h+v1TMwHLddYzQCfbsmVI6zKcZ51BmkGJamlXAlBY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fGq2KfWbgAf/NsJfUbtlmTqRrySrsjsh5AQKAw7qGmViy2otdewRKF+KgcKR2aPBJ7zYwZ8zL0LGtgYwGhXN4jHkCuEIUu7//ADiz+N6GL+IKuvcxD02o7EP7tOye1zTE4UNk19vgSZthEc6o28R5qrG2UytvjN+kmq10nLgbTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fadsxQWd; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fadsxQWd"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d91c22d27dso6536615ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 08:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789658367; x=1790263167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kcXKRIDcw5mAZxkYucxI77vzHbmXLBieOuahAT0hPgU=;
        b=fadsxQWdzqNpCRAH7E/+d1MYwR1y6TAbbhpYVzwQxJmm8l08Zz3p3lzhKoylmNNfxF
         YlWfmANe4qIK7nYjJVBvjxvSedqf7cbwLtSBiz5pfsScoeVnc55hUi37QfcbLF0ph2SX
         CN6andO3YEEZARbu5DEUMnlOc+KzlyNO2Xw0eH+M5gLrGM3sG/oqi1GbWM3xjDe//dwV
         xGWJLWktZJKSDtZ9tm9lk4aDKk4EJUS2FN/qbVUn57mV9tDgQZewscvZYJB4r5xDCb+1
         k7w9G4C/MmRvZXOH8t0Wtw0DKja8Fmi+8cTVOw+SN02R9LRE39czaOw0FFW5xSp4ynS6
         pqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789658367; x=1790263167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kcXKRIDcw5mAZxkYucxI77vzHbmXLBieOuahAT0hPgU=;
        b=ZI7B/ktyRVRn9K8vUVvxm4NWyhIDarKe4LmdyXTcFXbhKBM14uS2cLyNo82o6HF1nd
         jhm2jB/e8QjXeGjH/ZCeP7kWNDi3kUs8j8LrMn9EJhtUFKBlJ0LjCsE8R3KpluRJc+ox
         dkRWLeDRaIDA6K/YtYFEGZh9mlCtbt6u96hPG+pQkuh6lRC9DJjWhpj1BEwOhc7KlvII
         dGazsGA3EEg7c0OXb5WryrJ7oU98/iks1EDDsO1LO8oSUaLb7w0E4qnDFeX5utR0MEkK
         SBDq0cI/mVSUhUK5HVM557LZbSS2joy2x0cJr1CxqDWSUsrcyEA49fT7yOuOrwMB2VcA
         DqfA==
X-Gm-Message-State: AFuF++n8y0NaLgTRWevoGj04gLeBNpaprABL/LDzltdCaI0zY9KyT0as
	+m8FbGZJBDJ2T7DZjsDdUn3AaeiksDUlLdFlCpctm4aC/Pft9yoBZXH+lD8RnjvOnLo=
X-Gm-Gg: AYBFou2PQTGQcO0riLwoXI1t+KHu3c43bLc0EOQmDbo8xvZWKO4HS/QasrTooGm4r5u
	rbr7h1FtqY2cZjh1LMDtB+aypGDMckbQCjLrgnA+hKJ6n+EHvsGLCtHhN7Ru8bNso7ylzxe5KTY
	V2irTbYEBFExiNTNMZvcrLw3fZi+rmUBtTPE23/A8ss3ePLHHhz7cQgYfxZTYrGnFWD+xuT8pJm
	KT/IR9y96hU8vWGqqDOhR24ARtCDAMvYjtZ7qPBzxRFyG9f8+URfOCkrpSoO6juz74+YSV7AZPi
	bTLIFaEuBOcqr3++T+aSLqJeFoSRsFdc2xRPeo3mjbl9vDFr/B9oyQH9lPjAPdKF9gAsV9zhIU6
	95Dr6wkqHKXmM5CV51v6BPFA/X6K3CcvgInlIGaDnq0GUPX9tduyRveu0HWDYMee85ZSGUzZC48
	g0kZH3vrjc+PRtB1J+L3twnCOsdJZzsAoiDwPQsCoaBhDPPW6pTZMkAFBljpgKB8W82giekmc7q
	/J0ZYLthyd1zlKwsguTYu8=
X-Received: by 2002:a17:902:d54e:b0:2d9:6db:9fcb with SMTP id d9443c01a7336-2dd8e40cdd6mr157761115ad.11.1789658367416;
        Thu, 17 Sep 2026 08:19:27 -0700 (PDT)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89ebc548sm28789145ad.37.2026.09.17.08.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 08:19:26 -0700 (PDT)
From: MarkLee131 <kaixuanli0131@gmail.com>
X-Google-Original-From: MarkLee131 <kaixuan.li@ntu.edu.sg>
To: linux-ext4@vger.kernel.org
Cc: Kaixuan Li <kaixuanli0131@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
Subject: [BUG] ext4: stack OOB in set_flexbg_block_bitmap() via EXT4_IOC_GROUP_ADD
Date: Thu, 17 Sep 2026 23:19:14 +0800
Message-Id: <20260917151914.415604-1-kaixuan.li@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaixuan Li <kaixuanli0131@gmail.com>

EXT4_IOC_GROUP_ADD can make set_flexbg_block_bitmap() index two one-element
arrays at offset 1. KASAN reports a stack out-of-bounds read on v6.12.9 and
v7.2.4; a reproducer is below.

EXT4_IOC_GROUP_ADD requires CAP_SYS_RESOURCE, so this goes to the list
rather than security@kernel.org. The ioctl returns 0 whether or not the
read happens.

ext4_group_add() builds a one-element flex group descriptor whose arrays
are locals in its own frame:

	__u16 bg_flags = 0;
	...
	flex_gd.count = 1;
	flex_gd.groups = input;          /* the ioctl's single struct */
	flex_gd.bg_flags = &bg_flags;    /* one __u16 */
	err = ext4_flex_group_add(sb, inode, &flex_gd);

set_flexbg_block_bitmap() derives its index from a block number, not from
flex_gd->count (fs/ext4/resize.c):

	group  = ext4_get_group_number(sb, EXT4_C2B(sbi, first_cluster));
	start  = EXT4_B2C(sbi, ext4_group_first_block_no(sb, group));
	group -= flex_gd->groups[0].group;
	...
	if (flex_gd->bg_flags[group] & EXT4_BG_BLOCK_UNINIT) {
		BUG_ON(flex_gd->count > 1);
		continue;
	}
	...
	bh = sb_getblk(sb, flex_gd->groups[group].block_bitmap);

The BUG_ON tests flex_gd->count, not group, so it does not fire.

verify_group_input() bounds the three supplied blocks against
[start, start + input->blocks_count), but nothing bounds blocks_count
against EXT4_BLOCKS_PER_GROUP(sb). A blocks_count spanning more than one
group lets inode_table sit in group N+1, so group above becomes 1 while
both arrays hold one element.

The second access feeds a journalled write: the out-of-bounds 8 bytes
become the block number passed to sb_getblk(),
ext4_journal_get_write_access(), mb_set_bits() and
ext4_handle_dirty_metadata().

ext4_resize_fs() is not affected. ext4_setup_next_flex_gd() sets
blocks_count = EXT4_BLOCKS_PER_GROUP(sb) and ext4_alloc_group_tables()
keeps the tables inside the flex group, so group stays below flex_gd->count
there. Only EXT4_IOC_GROUP_ADD takes these numbers from userspace.

Reproducer
==========

blocks_count must be first_data_block + N * blocks_per_group, or
verify_group_input() stops at "Last group not full" first:

	truncate -s 64M img
	mke2fs -q -F -t ext4 -b 1024 -g 1024 -O ^has_journal img 4097
	mount -o loop img /mnt

Group 4 is the next group and carries no superblock backup, so overhead is
0. inode_table is the first block of group 5, which makes the index 1:

	struct ext4_new_group_input in = {
		.group		 = 4,
		.block_bitmap	 = 4097,
		.inode_bitmap	 = 4098,
		.inode_table	 = 5121,
		.blocks_count	 = 1088,
		.reserved_blocks = 0,
	};
	ioctl(fd_on_mnt, EXT4_IOC_GROUP_ADD, &in);	/* returns 0 */

KASAN
=====

v7.2.4, x86_64 defconfig plus CONFIG_KASAN=y CONFIG_KASAN_STACK=y
CONFIG_KASAN_INLINE=y, under QEMU:

	BUG: KASAN: stack-out-of-bounds in set_flexbg_block_bitmap+0x531/0x6a0
	Read of size 2 at addr ffff8880072b7b2a by task init/1
	CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 7.2.4 #1 PREEMPT(lazy)
	Call Trace:
	 <TASK>
	 set_flexbg_block_bitmap+0x531/0x6a0
	 ext4_flex_group_add+0x3885/0x5730
	 ext4_group_add+0xc13/0x14b0
	 ext4_ioctl_group_add+0x1a4/0x4a0

	BUG: KASAN: stack-out-of-bounds in set_flexbg_block_bitmap+0x646/0x6a0
	Read of size 8 at addr ffff8880072b7da8 by task init/1

Size 2 is bg_flags, size 8 is groups[1].block_bitmap. v6.12.9 gives the
same pair. set_flexbg_block_bitmap() and verify_group_input() are unchanged
in current master.

set_flexbg_block_bitmap() has computed the index this way since
33afdcc5402d ("ext4: add a function which sets up group blocks of a flex
bg"), v3.3.

Fix
===

Either bounds check works, and I do not know which you prefer:

  - reject blocks_count > EXT4_BLOCKS_PER_GROUP(sb) in
    verify_group_input(), which is what the single-group path means; or

  - bound group against flex_gd->count in set_flexbg_block_bitmap(), which
    also covers a future multi-group caller.

I can send a patch for either, and test one.

Kaixuan
