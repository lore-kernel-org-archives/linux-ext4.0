From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/11] ext4: Use generic helpers for quotaon and quotaoff
Date: Thu, 13 Nov 2014 09:36:00 -0800
Message-ID: <20141113173600.GB31481@infradead.org>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
 <1415739865-2438-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415739865-2438-8-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>  static const struct quotactl_ops ext4_qctl_sysfile_operations = {
> -	.quota_on_meta	= ext4_quota_on_sysfile,
> -	.quota_off	= ext4_quota_off_sysfile,
> +	.sysquota_on	= dquot_sysquota_on,
> +	.sysquota_off	= dquot_sysquota_off,
>  	.quota_sync	= dquot_quota_sync,
>  	.get_info	= dquot_get_dqinfo,
>  	.set_info	= dquot_set_dqinfo,

This vector now only has generic dquot_ methods.  Maybe move the
vector to fs/quota/dquot.c and allow multiple filesystems to share it?
