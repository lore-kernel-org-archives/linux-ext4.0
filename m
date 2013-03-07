From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Thu, 07 Mar 2013 17:36:07 +0900
Message-ID: <51385177.9030904@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:42766 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3CGIqh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 03:46:37 -0500
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r278kZ6c001028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 7 Mar 2013 17:46:35 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I found the performance problem that ext3 direct I/O sends large number of bio
unnecessarily when buffer_head is set BH_Boundary flag.

When we read/write a file sequentially, we will read/write not only
the data blocks but also the indirect blocks that may not be physically
adjacent to the data blocks. So ext3 sets BG_Boundary flag to submit
the previous I/O before reading/writing an indirect block.

However, in the case of direct I/O, the size of buffer_head
could be more than the blocksize. dio_send_cur_page() checks BH_Boundary flag
and then calls submit_bio() without calling dio_bio_add_page().
As a result, submit_bio() is called every one page and cause of high CPU usage.

The following patch fixes this problem only for ext3. At least ext2/3/4
don't need BH_Boundary flag for direct I/O because submit_bio() will be called
when the offset of buffer_head is discontinuous about the previous one.

---
@@ -926,7 +926,8 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
    set_buffer_new(bh_result);
 got_it:
    map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
-   if (count > blocks_to_boundary)
+   /* set bourdary flag for buffered I/O */
+   if (maxblocks == 1 && count > blocks_to_boundary)
        set_buffer_boundary(bh_result);
    err = count;
    /* Clean up and exit */
---

My simple performance test with/without the above patch shows us reducing
CPU usage.

-------------------------------------------------
|        | I/O time(s)| CPU used(%)| mem used(%)|
-------------------------------------------------
|default |     41.304 |     74.658 |     21.528 |
|patched |     40.948 |     58.325 |     21.857 |
-------------------------------------------------

environment:
  kernel: 3.8.0-rc7
  CPU:    Xeon E3-1220
  Memory: 8GB

Test detail:
  (1) create 48KB file
  (2) write 4096KB with O_DIRECT from the file offset 48KB (write only
      indirect blocks)
  (3) loop (2) at 1000 times

  I/O time means the time between (1) and (3), and CPU/memory usage is
  monitored by sar command.

When BH_Boundary flag is sets to buffer_head, we should call submit_bio()
once per the size of buffer_head. But I don't see the impact of
other filesystems that is used BH_Boundary.

Does anyone have any ideas about this problem?

Regards,
Kazuya Mio
