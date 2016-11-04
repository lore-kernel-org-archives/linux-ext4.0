From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/6 v2] fs: Provide function to unmap metadata for a
 range of blocks
Date: Fri, 4 Nov 2016 14:32:41 -0600
Message-ID: <20161104203241.GA11764@kernel.dk>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35792 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbcKDUcp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2016 16:32:45 -0400
Received: by mail-pf0-f169.google.com with SMTP id i88so56907651pfk.2
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2016 13:32:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 04 2016, Jan Kara wrote:
> Hello,
> 
> I've noticed that in several places we need to unmap metadata in buffer cache
> for a range of blocks and we do it by iterating over all blocks in given range.
> Let's provide a helper function for that and implement it in a way more
> efficient for larger ranges of blocks. Also cleanup other uses of
> unmap_unerlying_metadata().  The patches passed xfstests for ext2 and ext4.
> 
> Jens, can you merge these patches if they look fine to you?

Looks clean to me. There's a small typo ("used to used") in the comment
for patch #1, but I'll just correct that manually before applying.

-- 
Jens Axboe

