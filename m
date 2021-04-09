Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7956AC433ED
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Apr 2021 16:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 478DC610E5
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Apr 2021 16:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhDIQog (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 9 Apr 2021 12:44:36 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54432 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229665AbhDIQof (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2021 12:44:35 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 139Gi0DU016716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 9 Apr 2021 12:44:00 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F0DF715C3B12; Fri,  9 Apr 2021 12:43:59 -0400 (EDT)
Date:   Fri, 9 Apr 2021 12:43:59 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()
Message-ID: <YHCETyV70FNVO5u6@mit.edu>
References: <20210331033138.918975-1-yi.zhang@huawei.com>
 <20210331095920.GF30749@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331095920.GF30749@quack2.suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 31, 2021 at 11:59:20AM +0200, Jan Kara wrote:
> On Wed 31-03-21 11:31:38, Zhang Yi wrote:
> > When CONFIG_QUOTA is enabled, if we failed to mount the filesystem due
> > to some error happens behind ext4_orphan_cleanup(), it will end up
> > triggering a after free issue of super_block. The problem is that
> > ext4_orphan_cleanup() will set SB_ACTIVE flag if CONFIG_QUOTA is
> > enabled, after we cleanup the truncated inodes, the last iput() will put
> > them into the lru list, and these inodes' pages may probably dirty and
> > will be write back by the writeback thread, so it could be raced by
> > freeing super_block in the error path of mount_bdev().
> > 
> > After check the setting of SB_ACTIVE flag in ext4_orphan_cleanup(), it
> > was used to ensure updating the quota file properly, but evict inode and
> > trash data immediately in the last iput does not affect the quotafile,
> > so setting the SB_ACTIVE flag seems not required[1]. Fix this issue by
> > just remove the SB_ACTIVE setting.
> 
> Thanks for the patch. Let me rephrase the changelog a little:
> 
> When CONFIG_QUOTA is enabled and if we later fail to finish mounting the
> filesystem due to some error after ext4_orphan_cleanup(), we may hit use
> after free issues. The problem is that ext4_orphan_cleanup() sets SB_ACTIVE
> flag and so inodes processed during the orphan cleanup are put to the
> superblock's LRU list instead of being immediately destroyed. However the
> path handling error recovery after failed ->fill_super() call does not
> destroy inodes attached to the superblock and so they are left active in
> memory while the superblock is freed.
> 
> Originally, SB_ACTIVE setting was added so that updated quota information
> is not destroyed when we drop quota inode references after orphan cleanup.
> However VFS does not purge dirty inode pages without SB_ACTIVE flag for many
> years already. So just remove the hack with setting SB_ACTIVE flag from
> ext4_orphan_cleanup().
> 
> Also feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza

Applied, thanks.

					- Ted
