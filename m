Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742EFC282C3
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 11:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EFB72084A
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 11:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfAVLRE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:17:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:50802 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727663AbfAVLRD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Jan 2019 06:17:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8BE8AFB8;
        Tue, 22 Jan 2019 11:17:01 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C5E7C1E3E1E; Tue, 22 Jan 2019 12:17:00 +0100 (CET)
Date:   Tue, 22 Jan 2019 12:17:00 +0100
From:   Jan Kara <jack@suse.cz>
To:     yangerkun <yangerkun@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        miaoxie@huawei.com, houtao1@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH] ext2: add check for blocksize in ext2_fill_super
Message-ID: <20190122111700.GD13149@quack2.suse.cz>
References: <20190110053145.138518-1-yangerkun@huawei.com>
 <422fbc79-12a1-62d4-ee4a-0bc9b652cd89@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <422fbc79-12a1-62d4-ee4a-0bc9b652cd89@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello!

On Tue 15-01-19 20:46:01, yangerkun wrote:
> Could you please help me to check this patch?
> 
> Besides, i have notice that EXT2_MAX_BLOCK_SIZE has never been used before.
> So there maybe someone using ext2fs which blocksize exceed
> EXT2_MAX_BLOCK_SIZE in the os that page size exceed 4K? And if it's true,
> this patch will lead to a unused ext2fs.
> 
> Also, we can fix the problem by modify ext2_max_size, but it's difficult to
> get the accurate result, it may not a good idea too...

Thanks for your report and the patch! Ext2 is supposed to be usable for
block sizes between 1k and min(PAGE_SIZE, 64k). So rather than limiting
block size to 4k, we should fix ext2_max_size(). Will you send a new patch
or should I fix the problem? I agree it is difficult to come up with the
exact limit for a particular block size. But the computation does not have
to be exact - even the current one is not. It just has to be approximately
right and not allow any overflow. And BTW ext4 seems to have the same
overflow problem in its ext4_max_bitmap_size().

								Honza

> yangerkun wrote on 2019/1/10 13:31:
> > While mkfs with '-b 65536' and then mount this fs with arm 64KB page
> > size, function mount_fs will trigger WARNING because that ext2_max_size
> > will return value less than 0. Also, we cannot write any file in this
> > fs since the sb->s_maxbytes is less than 0. Avoid this by check blocksize
> > in ext2_fill_super like ext4_fill_super.
> > 
> > Signed-off-by: yangerkun <yangerkun@huawei.com>
> > ---
> >   fs/ext2/ext2.h  |  1 +
> >   fs/ext2/super.c | 15 +++++++++++++++
> >   2 files changed, 16 insertions(+)
> > 
> > diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> > index e770cd1..ba95316 100644
> > --- a/fs/ext2/ext2.h
> > +++ b/fs/ext2/ext2.h
> > @@ -177,6 +177,7 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
> >   #define EXT2_MIN_BLOCK_SIZE		1024
> >   #define	EXT2_MAX_BLOCK_SIZE		4096
> >   #define EXT2_MIN_BLOCK_LOG_SIZE		  10
> > +#define EXT2_MAX_BLOCK_LOG_SIZE		  12
> >   #define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
> >   #define	EXT2_ADDR_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (__u32))
> >   #define EXT2_BLOCK_SIZE_BITS(s)		((s)->s_blocksize_bits)
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index 73b2d52..029945e 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -960,6 +960,21 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> >   	}
> >   	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
> > +	if (blocksize < EXT2_MIN_BLOCK_SIZE ||
> > +		blocksize > EXT2_MAX_BLOCK_SIZE) {
> > +		ext2_msg(sb, KERN_ERR,
> > +				"Unsupported filesystem blocksize %d (%d log_block_size)",
> > +				blocksize, le32_to_cpu(es->s_log_block_size));
> > +		goto failed_mount;
> > +	}
> > +
> > +	if (le32_to_cpu(es->s_log_block_size) >
> > +		(EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE)) {
> > +			ext2_msg(sb, KERN_ERR,
> > +				"Invalid log block size: %u",
> > +				le32_to_cpu(es->s_log_block_size));
> > +			goto failed_mount;
> > +		}
> >   	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> >   		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
