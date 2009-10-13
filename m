From: Curt Wohlgemuth <curtw@google.com>
Subject: Help understanding prealloc space choice?
Date: Tue, 13 Oct 2009 11:06:35 -0700
Message-ID: <6601abe90910131106u3a569d51g1322fe6764a2fbb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:8822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967AbZJMSHq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 14:07:46 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n9DI6cD9010736
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 19:06:38 +0100
Received: from pzk5 (pzk5.prod.google.com [10.243.19.133])
	by zps19.corp.google.com with ESMTP id n9DI5Nfc000455
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 11:06:36 -0700
Received: by pzk5 with SMTP id 5so2171430pzk.18
        for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 11:06:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all:

I'm looking in ext4_mb_use_preallocated() and am seeing something odd.

First we look through the inode prealloc list, and see if we have a
preallocation that satisfies the allocation context:

       /* all fields in this condition don't change,
        * so we can skip locking for them */
       if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||
               ac->ac_o_ex.fe_logical >= pa->pa_lstart + pa->pa_len)
               continue;

       /* non-extent files can't have physical blocks past 2^32 */
       if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL) &&
               pa->pa_pstart + pa->pa_len > EXT4_MAX_BLOCK_FILE_PHYS)
               continue;

       /* found preallocated blocks, use them */
       spin_lock(&pa->pa_lock);
       if (pa->pa_deleted == 0 && pa->pa_free) {

            => Now we're good, and have an AC that satisfies us.
            => We call ext4_mb_use_inode_pa(ac, pa);


But ext4_mb_use_inode_pa() has this:

	BUG_ON(pa->pa_free < len);

Nowhere do we check the 'pa_free' value to decide if this preallocation is
okay to use.


Further down in ext4_mb_use_preallocated() we check the locality group
prealloc list; for this, we DO check pa_free:

         spin_lock(&pa->pa_lock);
         if (pa->pa_deleted == 0 &&
                         pa->pa_free >= ac->ac_o_ex.fe_len) {

                 cpa = ext4_mb_check_group_pa(goal_block,
                                                 pa, cpa);

So my question is:  Is it a bug that we don't check that an inode
preallocation has enough free blocks for the AC before we try to use it?  I
have hit the BUG_ON above at least once in my testing, but I can't
characterize what the workload was at the time (nor can I reproduce it...).

Thanks,
Curt
