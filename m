Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E103BC43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1272067D
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfDYPT2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:19:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46864 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfDYPT2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 11:19:28 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hJg9X-0001v8-7D; Thu, 25 Apr 2019 15:19:11 +0000
Date:   Thu, 25 Apr 2019 16:19:11 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vfs: Allow searching of the icache under RCU
 conditions [ver #2]
Message-ID: <20190425151911.GR2217@ZenIV.linux.org.uk>
References: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
 <155620453168.4720.4510967359017466912.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155620453168.4720.4510967359017466912.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 25, 2019 at 04:02:11PM +0100, David Howells wrote:
> Allow searching of the inode cache under RCU conditions - but with a
> footnote that this is redone under lock under certain conditions.
> 
> The following changes are made:
> 
>  (1) Use hlist_add_head_rcu() and hlist_del_init_rcu() to add and remove
>      an inode to/from a bucket.
> 
>  (2) In rehash_inode(), called by Coda to change the identifying parameters
>      on an inode during resolution of disconnected operation, lock
>      inode_hash_lock with write_seqlock(), which takes the spinlock and
>      bumps the sequence counter.
> 
>  (3) Provide __find_inode_rcu() and __find_inode_by_ino rcu() which do an
>      RCU-safe crawl through a hash bucket.
> 
>  (4) Provide find_inode_rcu() and find_inode_by_ino_rcu() which do a
>      read_seqbegin_or_lock() conditional lock-loop on inode_hash_lock to
>      cover searching the icache.  Normally this will work without needing
>      to retry, but in case (4), where an inode may be moved between lists,
>      we need to retry with the lock held.

Hmm...  Why do these stores to ->i_state need WRITE_ONCE, while an arseload
of similar in fs/fs-writeback.c does not?
