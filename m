From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/11] ext4: Use generic helpers for quotaon and quotaoff
Date: Tue, 18 Nov 2014 17:07:26 +0100
Message-ID: <20141118160726.GB29472@quack.suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
 <1415739865-2438-8-git-send-email-jack@suse.cz>
 <20141113173600.GB31481@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141113173600.GB31481@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 13-11-14 09:36:00, Christoph Hellwig wrote:
> >  static const struct quotactl_ops ext4_qctl_sysfile_operations = {
> > -	.quota_on_meta	= ext4_quota_on_sysfile,
> > -	.quota_off	= ext4_quota_off_sysfile,
> > +	.sysquota_on	= dquot_sysquota_on,
> > +	.sysquota_off	= dquot_sysquota_off,
> >  	.quota_sync	= dquot_quota_sync,
> >  	.get_info	= dquot_get_dqinfo,
> >  	.set_info	= dquot_set_dqinfo,
> 
> This vector now only has generic dquot_ methods.  Maybe move the
> vector to fs/quota/dquot.c and allow multiple filesystems to share it?
  Right. ocfs2 actually has the same vector now. I'll unify it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
