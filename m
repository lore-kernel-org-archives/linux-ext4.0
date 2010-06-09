From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: delalloc makes data=writeback safer
Date: Wed, 09 Jun 2010 16:19:27 +0400
Message-ID: <877hm8jt4g.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0FIMTb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 08:19:31 -0400
Received: by fxm8 with SMTP id 8so3531647fxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jun 2010 05:19:30 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Everybody know that writeback mode for ext3 is potentially result in
stale data in case of unclean umount. The same is true for ext4 with
nodelalloc.
But as far as i can see things is getting better in case of delalloc.
In case of delalloc we have following calltrace:
[writeback thread]
ext4_da_writepages
  journal_start()
  ext4_map_blocks() -> real block allocation
  mpage_da_submit_io() -> submit_bh() -> submit_bio()
  journal_stop()
So journal will be closed only after data was issued. 
And if journal->j_dev == journal->j_fs_dev (which is usually the case)
data will be serialized with metadata. So it looks like it is impassible
to see stale data even after unclean umount.

Do I miss something? May be this was already discussed before, 
if so please post a link to previous discussion.
