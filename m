From: Lubos Uhliarik <uhliarik@seznam.cz>
Subject: [RFC][PATCH 0/1] ext4: Undelete Feature for Ext4
Date: Tue, 18 Mar 2014 16:09:30 +0100
Message-ID: <1395155370.15587.9.camel@zerobox.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: lczerner@redhat.com, vojnar@fit.vutbr.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.seznam.cz ([77.75.76.43]:51835 "EHLO smtp2.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaCRPXH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2014 11:23:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi all,

I'm sending you a patch (see the 1/1 patch) which should make
undelete process for deleted files on ext4 easier. I do this 
patch as a part of my Barchelor's thesis with support of Red Hat
company. 

The main changes in patch are following:

a) commented out zeroing ex->ee_len, ee->start_hi and ee->start_lo,
because these entries are essential for undelete process

b) only in inode structure, storing original value of eh->depth and
eh->entries. These values are stored to unused entry eh_generation in
struct ext4_extent_header after all extents have been definitely
removed. eh->entries is 16 bits value and is stored in first half of 32
bits of eh->generation. eh->depth is also 16 bits value and is stored in
second half of eh->generation. For storing these valued, I wrote macros
to ext4_extents.h. It's should NOT cause problems to store values in 
eh->generation, because eh->generation is used only, when file is NOT
deleted. After delete process, eh->generation can have any value.

c) if deletion process removes extents from block, which is not inode
(eh->depth > 0), then I'm storing only eh->entries original value to
eh->generation, because eh->depth will stay untouched. 

d) if delete process removes all extent_idx structures from block, which
is not in inode (eh->depth > 0), then I'm storing also only eh->entries
original value. But in this case, I need to store original eh->entries
value for each level separately, because delete process is changing
eh->entries value during walking through extent tree. This problem is
solved by allocating array, where I will store original values


This patch shouldn't break ext4, I tested it with xfs_tests and tests 
were successfull.

I also successfully created undelete application, based on e2fslibs,
which demonstrates undelete process. (link:
https://github.com/uhliarik/ext4-undelete )


Thanks! 
Lubos Uhliarik





