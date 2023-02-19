Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8E0C6379F
	for <linux-ext4@archiver.kernel.org>; Sun, 19 Feb 2023 05:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBSFle (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 19 Feb 2023 00:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjBSFl2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Feb 2023 00:41:28 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EED14218
        for <linux-ext4@vger.kernel.org>; Sat, 18 Feb 2023 21:41:25 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 31J5etnQ024819
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Feb 2023 00:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1676785258; bh=jGxePgwpQPwIO+m8ahbg2fuQHJ7irtUy4tuNjDXflZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BPms9DVNQa3hGOD6RxYv7UEb689EVqYi4U8PiAE2ncnfVs8PtX23Dy1tPLY2L7p/i
         TXrQIWuhpeLMzKHevw5bozA4hjTRIwBqOCH4PIJsALi4qYJnTG/X/6IMdnyp9LePF/
         fHC30dztSwlrmj7O1TGgr4c868RFIbWXrBHwh4I5ndjRIsmJjtoTB1H1mzTAdtqU+g
         +iucMpoROP8HhKVyw035/XxkyuXZRErTlH2VMsh4HJ/IwNnLRW9nccfwg/I9gstVA0
         FbvNrqkz7SaXzxyxMFYh2VFQyy+4wsHDlJ7eHGxaNr5w+Db8WanWucR/Ud9+I135fb
         xd9VVthQHOEkQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C184315C35A3; Sun, 19 Feb 2023 00:40:55 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     jack@suse.com, Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        zhanchengbin1@huawei.com, libaokun1@huawei.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH v4] jbd2: Fix data missing when reusing bh which is ready to be checkpointed
Date:   Sun, 19 Feb 2023 00:40:43 -0500
Message-Id: <167678522172.2723470.1837475559242554356.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230110015327.1181863-1-chengzhihao1@huawei.com>
References: <20230110015327.1181863-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 10 Jan 2023 09:53:27 +0800, Zhihao Cheng wrote:
> Following process will make data lost and could lead to a filesystem
> corrupted problem:
> 
> 1. jh(bh) is inserted into T1->t_checkpoint_list, bh is dirty, and
>    jh->b_transaction = NULL
> 2. T1 is added into journal->j_checkpoint_transactions.
> 3. Get bh prepare to write while doing checkpoing:
>            PA				    PB
>    do_get_write_access             jbd2_log_do_checkpoint
>     spin_lock(&jh->b_state_lock)
>      if (buffer_dirty(bh))
>       clear_buffer_dirty(bh)   // clear buffer dirty
>        set_buffer_jbddirty(bh)
> 				    transaction =
> 				    journal->j_checkpoint_transactions
> 				    jh = transaction->t_checkpoint_list
> 				    if (!buffer_dirty(bh))
> 		                      __jbd2_journal_remove_checkpoint(jh)
> 				      // bh won't be flushed
> 		                    jbd2_cleanup_journal_tail
>     __jbd2_journal_file_buffer(jh, transaction, BJ_Reserved)
> 4. Aborting journal/Power-cut before writing latest bh on journal area.
> 
> [...]

Applied, thanks!

[1/1] jbd2: Fix data missing when reusing bh which is ready to be checkpointed
      commit: e6b9bd7290d334451ce054e98e752abc055e0034

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
