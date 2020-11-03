Return-Path: <SRS0=y36c=EJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E35C2D0A3
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Nov 2020 16:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF3FD20756
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Nov 2020 16:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgKCQwi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 3 Nov 2020 11:52:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:33086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgKCQwi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 3 Nov 2020 11:52:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7095AB240;
        Tue,  3 Nov 2020 16:52:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3B75E1E12FB; Tue,  3 Nov 2020 17:52:37 +0100 (CET)
Date:   Tue, 3 Nov 2020 17:52:37 +0100
From:   Jan Kara <jack@suse.cz>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
Subject: Re: [PATCH 07/10] ext4: misc fast commit fixes
Message-ID: <20201103165237.GK3440@quack2.suse.cz>
References: <20201031200518.4178786-1-harshadshirwadkar@gmail.com>
 <20201031200518.4178786-8-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031200518.4178786-8-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat 31-10-20 13:05:15, Harshad Shirwadkar wrote:
> This patch adds a small number of misc fast commit fixes. Along with
> functional fixes such as setting the right buffer flags, there also
> typo fixes and comment additions.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Again, please don't merge logically separate fixes into one commit.

> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 00dc668e052b..10855cd230c7 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -422,9 +422,13 @@ static inline int ext4_journal_force_commit(journal_t *journal)
>  static inline int ext4_jbd2_inode_add_write(handle_t *handle,
>  		struct inode *inode, loff_t start_byte, loff_t length)
>  {
> -	if (ext4_handle_valid(handle))
> +	if (ext4_handle_valid(handle)) {
> +		ext4_fc_track_range(handle, inode,
> +			start_byte >> inode->i_sb->s_blocksize_bits,
> +			(start_byte + length) >> inode->i_sb->s_blocksize_bits);
>  		return jbd2_journal_inode_ranged_write(handle,
>  				EXT4_I(inode)->jinode, start_byte, length);
> +	}

Why this change? A good changelog would tell me... I'm suspicious here
because ext4_jbd2_inode_add_write() gets called only in data=ordered mode
but fastcommit can run also in data=writeback mode...

I suppose this is for the mmap coverage we were speaking about. Now that
I'm speaking about it again maybe the ext4_fc_track_range() call in
ext4_map_blocks() is actually enough? I mean once we allocate blocks for a
range (either from page fault, write, or writeback of delalloc), they will
become properly tracked in ext4_map_blocks() and that's all we need? But
then I'm missing why we have so many ext4_fc_track_range() calls around the
code... Can you please explain?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
