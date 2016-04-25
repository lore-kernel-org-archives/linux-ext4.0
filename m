From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix data exposure after a crash
Date: Mon, 25 Apr 2016 12:24:58 +0200
Message-ID: <20160425102458.GC4365@quack2.suse.cz>
References: <1459354767-8693-1-git-send-email-jack@suse.cz>
 <1459354767-8693-2-git-send-email-jack@suse.cz>
 <20160424034813.GG20980@thunk.org>
 <20160424045551.GI20980@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Weller.Huang@cn.bosch.com, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160424045551.GI20980@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 24-04-16 00:55:51, Ted Tso wrote:
> I had to add a !IS_NOQUOTA check:
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 576f64a..250c2df 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -693,6 +693,7 @@ out_sem:
>  		if (map->m_flags & EXT4_MAP_NEW &&
>  		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
>  		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
> +		    !IS_NOQUOTA(inode) &&
>  		    ext4_should_order_data(inode)) {
>  			ret = ext4_jbd2_file_inode(handle, inode);
>  			if (ret)
> 
> 
> In order to prevent crashes when writing to the quota file (see
> below).

Good catch. The fix looks correct to me, thanks for fixing this up. Since
data for quota files is actually journalled, it may be actually a cleaner
fix to reflect this in ext4_inode_journal_mode() and thus
ext4_should_order_data() would catch this case. But this has more potential
for breakage elsewhere so I will do that as a separate cleanup patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
