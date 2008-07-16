From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Suggestions for a 64bit bitmap api
Date: Wed, 16 Jul 2008 14:12:02 +0200
Message-ID: <87y742110t.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48933 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYGPMME (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 08:12:04 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate03.web.de (Postfix) with ESMTP id 15616E3F57D1
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:12:03 +0200 (CEST)
Received: from [85.216.73.182] (helo=frosties.localdomain)
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1KJ5rW-0007tD-00
	for linux-ext4@vger.kernel.org; Wed, 16 Jul 2008 14:12:03 +0200
Received: from mrvn by frosties.localdomain with local (Exim 4.69)
	(envelope-from <goswin-v-b@web.de>)
	id 1KJ5rW-00043L-6R
	for linux-ext4@vger.kernel.org; Wed, 16 Jul 2008 14:12:02 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

which api would you prefer?

Option 1
========

typedef enum {TYPE1, TYPE2} bitmap_type;

struct ext2fs_abstract_bitmap {
  bitmap_type type;
};

struct ext2fs_type1_bitmap {
  bitmap_type type;
  type1_data data;
};

struct ext2fs_type2_bitmap {
  bitmap_type type;
  type2_data data;
};

int ext2fs_fast_test_block_type1_bitmap(ext2fs_type1_bitmap *map, blk64_t i);
int ext2fs_fast_test_block_type2_bitmap(ext2fs_type2_bitmap *map, blk64_t i);
int ext2fs_fast_test_block_abstract_bitmap(ext2fs_abstract_bitmap *map, blk64_t i) {
  switch(map->type) {
    case TYPE1: return ext2fs_fast_test_block_type1_bitmap((ext2fs_type1_bitmap*)map, i);
    case TYPE2: return ext2fs_fast_test_block_type2_bitmap((ext2fs_type2_bitmap*)map, i);
  };
  return 0;
}


Option 2
========

struct ext2fs_abstract_bitmap {
  int (*fast_test_block)(void *map, blk64_t i);
  void *map;
};

int ext2fs_fast_test_block_abstract_bitmap(ext2fs_abstract_bitmap *map, blk64_t i) {
  return map->fast_test_block(map->map, i);
}


Option 3
========

struct ext2fs_bitmap_ops {
  int (*fast_test_block)(ext2fs_abstract_bitmap *map, blk64_t i); 
};

struct ext2fs_abstract_bitmap {
  ext2fs_bitmap_ops *ops;
};

struct ext2fs_type1_bitmap {
  ext2fs_bitmap_ops *ops;
  type1_data data;
};

struct ext2fs_type2_bitmap {
  ext2fs_bitmap_ops *ops;
  type2_data data;
};

int ext2fs_fast_test_block_abstract_bitmap(ext2fs_abstract_bitmap *map, blk64_t i) {
  return map->ops->fast_test_block(map, i);
}


Or something completly different?

MfG
        Goswin
