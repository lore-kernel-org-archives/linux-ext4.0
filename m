From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Date: Sun, 4 Jul 2010 15:06:05 -0600
Message-ID: <A4F0A2FD-2E7E-4694-BBF0-054DE680B0CE@dilger.ca>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100630233614.32422.97038.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-06-30, at 17:36, David Howells wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem.

I think we could spend forever discussing minor details (e.g. if it would be better to put the st_result_mask as the first field, or at least before st_gen), but it looks fairly reasonable as-is.

> When the system call is executed, the request_mask bitmask is read from the
> parameter block to work out what the user is requesting.  If params is NULL, then request_mask will be assumed to be XSTAT_REQUEST__GET_ANYWAY.

I think the only reasonable default if params == NULL is to return XSTAT_REQUEST__BASIC_STATS.  The value of XSTAT_REQUEST__EXTENDED_STATS may (AFAIK) change in the kernel in the future as the struct xstat gets more fields, unless that is not the intention.  The other option would be to rename this mask XSTAT_REQUEST__BASIC_XSTATS to indicate it represents (forever) all of the fields in the original struct xstat.

> +int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> {
> +
> +	stat->result_mask |= XSTAT_REQUEST_GEN | XSTAT_REQUEST_DATA_VERSION;
> +	stat->gen = inode->i_generation;
> +	stat->data_version = inode->i_version;

You didn't update the field names in any of the kernel patches,

> @@ -994,6 +994,8 @@ int ecryptfs_getattr(struct vfsmount *mnt,
> +	lower_stat.query_flags = stat->query_flags;
> +	lower_stat.request_mask = stat->request_mask | XSTAT_REQUEST_BLOCKS;
> 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
> 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);


Likewise, this doesn't have the newer field names.  I also don't understand why this is adding in the XSTAT_REQUEST_BLOCKS mask when that isn't requested by the caller?

> int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> {
> +	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
> +					    XSTAT_REQUEST_CTIME |
> +					    XSTAT_REQUEST_DATA_VERSION
> +					    )) &&
> +	    S_ISREG(inode->i_mode)
> +	    ) {

Minor nit - the parenthesis placement here looks decidedly unLinuxy.  Normally I think it should look like:

	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
					    XSTAT_REQUEST_CTIME |
					    XSTAT_REQUEST_DATA_VERSION)) &&
	    S_ISREG(inode->i_mode)) {

> +	if (force || stat->request_mask & (XSTAT_REQUEST__BASIC_STATS |
> +					   XSTAT_REQUEST_DATA_VERSION)
> +	    ) {

Likewise, I think the right style here is:

	if (force || stat->request_mask & (XSTAT_REQUEST__BASIC_STATS |
					   XSTAT_REQUEST_DATA_VERSION)) {


Cheers, Andreas
