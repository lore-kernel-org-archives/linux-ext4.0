From: ankijain@codeaurora.org
Subject: Kernel panic in ext4_ext_drop_refs
Date: Mon, 11 Sep 2017 10:40:23 +0530
Message-ID: <c5d90b6ba6826fb0d6ab245befdfc405@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46126 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdIKFKY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Sep 2017 01:10:24 -0400
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 296386071D
        for <linux-ext4@vger.kernel.org>; Mon, 11 Sep 2017 05:10:23 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

We are facing  issue use after free/un-initialized in ext4 delayed 
allocation path for write request to a file.

Details:
machine arm64
kernel : 4.9.40

Issue detail:
Panic is occurred while accessing uninitialized/free path variable 
inside ext4_ext_drop_refs()
ext4_ext_drop_refs(
     path = 0xFFFFFFC757A85C00 -> (
       p_block = 0x6B6B6B6B6B6B6B6B,
       p_depth = 0x6B6B,
       p_maxdepth = 0x6B6B,
       p_ext = 0x6B6B6B6B6B6B6B6B,
       p_idx = 0x6B6B6B6B6B6B6B6B,
       p_hdr = 0x6B6B6B6B6B6B6B6B,
       p_bh = 0x6B6B6B6B6B6B6B6B))

This path variable is representing extent path from root extent to leaf 
of requested logical block of file.
we have allocated memory for this path variable inside 
ext4_find_extent() locally and trying to free it inside 
ext4_ext_drop_refs().
http://elixir.free-electrons.com/linux/v4.9.40/source/fs/ext4/extents.c#L894 
   ----> allocation happen without any error.
http://elixir.free-electrons.com/linux/v4.9.40/source/fs/ext4/extents.c#L4620 
  ----> trying to free previously allocated memory.

Device is running in low memory condition.
	PAGES        TOTAL      PERCENTAGE
  FREE     6720      26.2 MB    0% of TOTAL MEM

could anyone help us to find, in which scenario this path variable can 
get free/uninitialized before ext4_ext_drop_refs()?

Unable to handle kernel paging request at virtual address 6b6b6b6b6b6bcb
<1>[ 4072.876804] pgd = ffffffc7b6c91000
<1>[ 4072.885604] [6b6b6b6b6b6bcb] *pgd=0000000000000000
  __brelse+0x18/0x50
  ext4_ext_drop_refs+0x3c/0x5c
  ext4_ext_map_blocks+0x418/0x1b34
  ext4_da_get_block_prep+0x200/0x4fc
  __block_write_begin_int+0x160/0x630
  __block_write_begin+0x3c/0x48fs stack.
  ext4_da_write_begin+0x17c/0x574block layer issue (from ritesh)
  generic_perform_write+0xc8/0x1d4uid issue
  __generic_file_write_iter+0x15c/0x1a8
  ext4_file_write_iter+0x108/0x354
  new_sync_write+0xd8/0x124
  vfs_write+0x15c/0x1d0
  SyS_pwrite64+0xb0/0xc8
  __sys_trace_return+0x0/0x4
