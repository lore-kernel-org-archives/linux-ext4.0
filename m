Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47164 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAELi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:11:38 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 0/7] ext4 long-lived issues, part two
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Message-ID: <fc0fb5ab-2272-8cad-4852-a1c9532bafc5@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:12:12 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've found one more batch of long-lived ext4 issues,
most of them are lost brelse + two leaks on rollback in ext4_fill_super.

Oldest one was found in 2.6.23, last one -- in 4.18.

Vasily Averin (7):
  ext4: lost brelse in __ext4_read_dirblock()
  ext4: possible sbi->s_group_desc leak in ext4_fill_super
  ext4: lost release of s_journal_flag_rwsem on rollback in
    ext4_fill_super
  ext4: lost brelse in ext4_xattr_get_block()
  ext4: bs.bh cleanup before re-using in ext4_xattr_block_find()
  ext4: lost brelse in ext4_xattr_move_to_block()
  ext4: lost brelse in ext4_expand_extra_isize_ea()

 fs/ext4/namei.c |  1 +
 fs/ext4/super.c |  4 +++-
 fs/ext4/xattr.c | 15 ++++++++++++---
 3 files changed, 16 insertions(+), 4 deletions(-)

-- 
2.17.1
