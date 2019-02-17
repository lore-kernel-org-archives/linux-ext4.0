Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E714C10F00
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 00:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C817222A3
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 00:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfBQA1Z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 16 Feb 2019 19:27:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52892 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfBQA1Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2019 19:27:24 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.91 #2 (Red Hat Linux))
        id 1gvAI8-0002rx-Ve; Sun, 17 Feb 2019 00:26:45 +0000
Date:   Sun, 17 Feb 2019 00:26:44 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, jack@suse.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        yuchao0@huawei.com, hughd@google.com, hch@infradead.org,
        richard@nod.at, dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-mm@kvack.org,
        amir73il@gmail.com
Subject: Re: [PATCH v2] vfs: don't decrement i_nlink in d_tmpfile
Message-ID: <20190217002644.GT2217@ZenIV.linux.org.uk>
References: <20190214234908.GA6474@magnolia>
 <20190215223925.GO32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215223925.GO32253@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 15, 2019 at 02:39:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> d_tmpfile was introduced to instantiate an inode in the dentry cache as
> a temporary file.  This helper decrements the inode's nlink count and
> dirties the inode, presumably so that filesystems could call new_inode
> to create a new inode with nlink == 1 and then call d_tmpfile which will
> decrement nlink.
> 
> However, this doesn't play well with XFS, which needs to allocate,
> initialize, and insert a tempfile inode on its unlinked list in a single
> transaction.  In order to maintain referential integrity of the XFS
> metadata, we cannot have an inode on the unlinked list with nlink >= 1.
> 
> XFS and btrfs hack around d_tmpfile's behavior by creating the inode
> with nlink == 0 and then incrementing it just prior to calling
> d_tmpfile, anticipating that it will be reset to 0.
> 
> Everywhere else, it appears that nlink updates and persistence is
> the responsibility of individual filesystems.  Therefore, move the nlink
> decrement out of d_tmpfile into the callers, and require that callers
> only pass in inodes with nlink already set to 0.

NAK.  You are changing semantics of existing helper, requiring to add
boilerplate to existing users.  With zero indication that such need
has appeared - no warnings, etc.

If you need a variant that wouldn't do nlink decrement, just add it
and turn the existing one into a wrapper.  Yield smaller patch, at that...
