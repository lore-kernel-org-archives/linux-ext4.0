From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: handle errors on ext4_commit_super
Date: Sat, 21 Apr 2018 15:12:29 +0200
Message-ID: <20180421131229.cc52gzqqtpmckrx3@quack2.suse.cz>
References: <20180330014429.27824-1-jaegeuk@kernel.org>
 <20180419155957.GB81439@jaegeuk-macbookpro.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419155957.GB81439@jaegeuk-macbookpro.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 19-04-18 08:59:57, Jaegeuk Kim wrote:
> When remounting ext4 from ro to rw, currently it allows its transition,
> even if ext4_commit_super() returns EIO. Even worse thing is, after that,
> fs/buffer complains buffer dirty bits like:
> 
>  Call trace:
>  [<ffffff9750c259dc>] mark_buffer_dirty+0x184/0x1a4
>  [<ffffff9750cb398c>] __ext4_handle_dirty_super+0x4c/0xfc
>  [<ffffff9750c7a9fc>] ext4_file_open+0x154/0x1c0
>  [<ffffff9750bea51c>] do_dentry_open+0x114/0x2d0
>  [<ffffff9750bea75c>] vfs_open+0x5c/0x94
>  [<ffffff9750bf879c>] path_openat+0x668/0xfe8
>  [<ffffff9750bf8088>] do_filp_open+0x74/0x120
>  [<ffffff9750beac98>] do_sys_open+0x148/0x254
>  [<ffffff9750beade0>] SyS_openat+0x10/0x18
>  [<ffffff9750a83ab0>] el0_svc_naked+0x24/0x28
>  EXT4-fs (dm-1): previous I/O error to superblock detected
>  Buffer I/O error on dev dm-1, logical block 0, lost sync page write
>  EXT4-fs (dm-1): re-mounted. Opts: (null)
>  Buffer I/O error on dev dm-1, logical block 80, lost async page write
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>

Looks mostly good. Just:

> @@ -5190,8 +5190,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	}
>  
>  	ext4_setup_system_zone(sb);
> -	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY))
> -		ext4_commit_super(sb, 1);
> +	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
> +		err = ext4_commit_super(sb, 1);
> +		goto restore_opts;
> +	}

Why is goto restore_opts unconditional here?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
