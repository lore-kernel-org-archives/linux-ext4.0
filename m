From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 0/5] ext4: try to fix up es regressions
Date: Wed,  6 Mar 2013 22:17:10 +0800
Message-ID: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49450 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3CFOCL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Mar 2013 09:02:11 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so6076043pbc.36
        for <linux-ext4@vger.kernel.org>; Wed, 06 Mar 2013 06:02:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

The patch series tries to fixup some regressions after applied the extent
status tree.  These patches have rebased against the latest dev branch of
ext4 and have been tested by xfstests.

After rebased the latest dev branch, two patches have been dropped because
they have been applied into the branch.  A new patch is added, which tries
to fix up a wrong return value in ext4_split_extent().  Otherwise, there
are two major changes in this version.  The first one is to improve the
self-testing-infrastructure according to Dmitry's comment.  The second one
is to improve the zero out code.

After applied this patch series, I havn't seen the warning messages from
self-testing infrastructure except the following cases.

 - xfstests #13 with bigalloc or with no journal
 - xfstests #223 with dioread_nolock
The reason is that when we lookup a block mapping from status tree
i_data_sem locking won't be taken.  So there is a race window that an 
unwritten extent could be converted by end_io when we compare the result
between extent tree and status tree.

Dmitry, Ted, could you please confirm that this patch series can fix the
defrag regression?  Thank you so much.  Until now I run #300 and #301 a
lot times but I failed to hit this regression. :-(

*Big Note*
When I am testing this patch series, I found some regressions in dev branch.
Here is a note.  These regressions could be hitted by running test case
serveral times.  So If we just run xfstests one time, they could be missed.

 - xfstests #74 with data=journal
 - xfstests #83 with bigalloc
Some threads could be blocked for 120s.

 - xfstests #247 with data=journal
Some warning messages are printed by ext4_releasepage.  We hit
WARN_ON(PageChecked(page)) in this function.  But the test case itself can
pass.

 - xfstests #269 with dioread_nolock
The system will hang

I don't paste full details here to make description clearly.  I will go on
tracing these problems.  I am happy to provide full details if some one
want to take a close look at these problems.

v2 <- v1:
 * Improve self-testing infrastructure
 * Improve zero out code
 * Fix a wrong return value in ext4_split_extent

v1: http://permalink.gmane.org/gmane.comp.file-systems.ext4/37338

Thanks,
						- Zheng

Dmitry Monakhov (1):
  ext4: add self-testing infrastructure to do a sanity check

Zheng Liu (4):
  ext4: improve ext4_es_can_be_merged() to avoid a potential overflow
  ext4: fix wrong m_len value after unwritten extent conversion
  ext4: update extent status tree after an extent is zeroed out
  ext4: fix wrong the number of the allocted blocks in
    ext4_split_extent

 fs/ext4/extents.c        |  45 ++++++++--
 fs/ext4/extents_status.c | 212 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/extents_status.h |   9 ++
 fs/ext4/inode.c          | 106 ++++++++++++++++++++++++
 4 files changed, 362 insertions(+), 10 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

