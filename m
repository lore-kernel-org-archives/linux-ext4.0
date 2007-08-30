From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 0/8][e2fsprogs] 64-bit block number support - first part
Date: Thu, 30 Aug 2007 17:28:35 +0200
Message-ID: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43676 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291AbXH3N0e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a series of 8 patches that prepares for the 64-bit block number support in e2fsprogs:
- change a few variable types to blk_t type to support 64-bit block numbers in a next step,

- introduce a new option to mkfs to build ext4 filesystems with larger group descriptor sizes,

- introduce helper functions, similar to those existing in the ext4 kernel code, to access 64-bit block counters split in two 32-bit words.

Code compiled and "make check" passed.

The patchset is composed of the following patches:
1/8 :  use existing function ext2fs_group_first_block()
    This function will be change in a next step to support 64-bit block numbers.
    This patch will allow to make the change in a single place.

2/8 : convert block number definition to blk_t

3/8 : add new -D <desc-size> option to mkfs

4/8 : add new macro to get descriptor number

5/8 : add new inline functions to get blocks counters
6/8 : change access to the filesystem blocks counter
7/8 : change access to the reserved blocks counter
8/8 : change access to the free blocks counter

Regards
  Valerie
