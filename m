From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze
Date: Mon, 10 Mar 2014 06:34:51 -0700
Message-ID: <20140310133451.GA17807@infradead.org>
References: <217983071.143460.1385453196946.JavaMail.zimbra@rapitasystems.com>
 <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com>
 <20131126125826.GA4503@quack.suse.cz>
 <622177618.727.1393062606061.JavaMail.zimbra@rapitasystems.com>
 <20140224095525.GA20532@quack.suse.cz>
 <20140224154532.GB11992@fieldses.org>
 <20140225102126.GB1669@quack.suse.cz>
 <20140304164306.GC12805@fieldses.org>
 <20140304190442.GE12805@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Rahtz <mrahtz-lFL+a/sBLVi/3pe1ocb+swC/G2K4zDHf@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140304190442.GE12805-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 04, 2014 at 02:04:42PM -0500, J. Bruce Fields wrote:
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 6d7be3f..eea5ad1 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -404,6 +404,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
>  	umode_t		ftype = 0;
>  	__be32		err;
>  	int		host_err;
> +	bool		get_write_count;
>  	int		size_change = 0;
>  
>  	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
> @@ -411,10 +412,18 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
>  	if (iap->ia_valid & ATTR_SIZE)
>  		ftype = S_IFREG;
>  
> +	/* Callers that do fh_verify should do the fh_want_write: */
> +	get_write_count = !fhp->fh_dentry;

Eww, this is nasty.  Given that there are only 6 callers of nfsd_setattr
in total, and only half of these might cause size changes I'd rather
deal with this properly, e.g. by taking both the fh_verify into the
callers.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
