From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Count journal as bsddf overhead in ext3_statfs
Date: Wed, 16 Oct 2013 14:29:48 +0200
Message-ID: <20131016122948.GB14278@quack.suse.cz>
References: <525DD38D.7060705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab3JPM3u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Oct 2013 08:29:50 -0400
Content-Disposition: inline
In-Reply-To: <525DD38D.7060705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-10-13 18:45:17, Eric Sandeen wrote:
> ext4 counts journal space as bsddf overhead, but ext3 does not.
> 
> For some reason when I patched ext4 I thought I should leave
> ext3 alone, but frankly it makes more sense to fix it, I think.
> 
> Otherwise we get inconsistent behavior from ext3 under ext3.ko,
> and ext3 under ext4.ko, which is not at all desirable...
> 
> This is testable by xfstests shared/289, though it will need
> modification because it currently special-cases ext3.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  OK, fair enough. Applied to my tree.

							Honza

> ---
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index c50c761..37fd31e 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2825,6 +2825,10 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
>  		 * bitmap, and an inode table.
>  		 */
>  		overhead += ngroups * (2 + sbi->s_itb_per_group);
> +
> +		/* Add the journal blocks as well */
> +                overhead += sbi->s_journal->j_maxlen;
> +
>  		sbi->s_overhead_last = overhead;
>  		smp_wmb();
>  		sbi->s_blocks_last = le32_to_cpu(es->s_blocks_count);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
