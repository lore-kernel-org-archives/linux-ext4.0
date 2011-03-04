From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] ext3: Always set dx_node's fake_dirent explicitly.
Date: Fri, 4 Mar 2011 15:23:46 -0700
Message-ID: <19B19E0F-3843-454C-81AF-4EBB245A034E@dilger.ca>
References: <4D71615D.30306@redhat.com> <4D7161D8.8010509@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Lachlan McIlroy <lmcilroy@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10400 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab1CDWXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Mar 2011 17:23:47 -0500
In-Reply-To: <4D7161D8.8010509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-04, at 3:04 PM, Eric Sandeen wrote:
> (crossport of 1f7bebb9e911d870fa8f997ddff838e82b5715ea
> by Andreas Schlick <schlick@lavabit.com>)
> 
> When ext3_dx_add_entry() has to split an index node, it has to ensure that
> name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
> won't recognise it as an intermediate htree node and consider the htree to
> be corrupted.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Should also be sent to stable I think.

> (V2: fix subject and commit and formatting)
> 
> While it's a simple one liner, this took me forever to (re-)find.
> 
> kill_ext3_now++;
> 
> That is all. ;)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index b27ba71..75c968e 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1540,8 +1540,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 			goto cleanup;
> 		node2 = (struct dx_node *)(bh2->b_data);
> 		entries2 = node2->entries;
> +		memset(&node2->fake, 0, sizeof(struct fake_dirent));
> 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
> -		node2->fake.inode = 0;
> 		BUFFER_TRACE(frame->bh, "get_write_access");
> 		err = ext3_journal_get_write_access(handle, frame->bh);
> 		if (err)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





