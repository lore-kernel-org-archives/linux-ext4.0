From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mbcache: fix to detect failure of register_shrinker
Date: Mon, 16 May 2016 17:31:40 +0200
Message-ID: <20160516153140.GE21714@quack2.suse.cz>
References: <1463411798-2597-1-git-send-email-chao@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.cz, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Chao Yu <yuchao0@huawei.com>
To: Chao Yu <chao@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463411798-2597-1-git-send-email-chao@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 16-05-16 23:16:38, Chao Yu wrote:
> From: Chao Yu <yuchao0@huawei.com>
> 
> register_shrinker in mb_cache_create may fail due to no memory. This
> patch fixes to do the check of return value of register_shrinker and
> handle the error case, otherwise mb_cache_create may return with no
> error, but losing the inner shrinker.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>

Thanks for fixing this. The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
