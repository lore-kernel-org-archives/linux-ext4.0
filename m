From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove abnormal set for I_DATA_SEM subclass
Date: Sun, 22 Jul 2018 18:08:41 -0400
Message-ID: <20180722220841.GA3358@thunk.org>
References: <1531123108-45918-1-git-send-email-junil0814.lee@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, junil0814.lee@MIT.EDU
To: Junil Lee <junil0814.lee@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531123108-45918-1-git-send-email-junil0814.lee@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 09, 2018 at 04:58:28PM +0900, Junil Lee wrote:
> The -EBUSY return value of dquot_enable() function means that just
> want to update flags. If some users make a duplicate request to update
> flags, lockdep could catch the false positive casued by needing to
> allocate a quota block from inside ext4_map_blocks(), while holding
> i_data_sem for a data inode. This results in this complaint:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&s->s_dquot.dqio_mutex);
>                                lock(&ei->i_data_sem);
>                                lock(&s->s_dquot.dqio_mutex);
>   lock(&ei->i_data_sem);

How does this happen in practice?  The function ext4_quota_enable() is
only called by ext4_enable_quotas(), and I don't see the code path
where this would happen.  And if it does it would be resulting an
EXT4-fs warning message getting printing indicating that a failure to
enable quotas with an error of EBUSY.  So how does this happen that
"users would make a duplicate request to update flags"?

       	     	    	      	      	 	- Ted
