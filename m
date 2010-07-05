From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats
	available [ver #3]
Date: Mon, 05 Jul 2010 15:10:15 +0100
Message-ID: <4055.1278339015@redhat.com>
References: <A4F0A2FD-2E7E-4694-BBF0-054DE680B0CE@dilger.ca>
	<20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <A4F0A2FD-2E7E-4694-BBF0-054DE680B0CE@dilger.ca>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> > Add a pair of system calls to make extended file stats available,
> > including file creation time, inode version and data version where
> > available through the underlying filesystem.
> 
> I think we could spend forever discussing minor details (e.g. if it would be
> better to put the st_result_mask as the first field, or at least before
> st_gen), but it looks fairly reasonable as-is.

I just arranged things such that all the fields of the same type were together
for packing purposes, but st_result_mask could easily be brought to the front
without upsetting structure packing.

> > When the system call is executed, the request_mask bitmask is read from
> > the parameter block to work out what the user is requesting.  If params is
> > NULL, then request_mask will be assumed to be XSTAT_REQUEST__GET_ANYWAY.
> 
> I think the only reasonable default if params == NULL is to return
> XSTAT_REQUEST__BASIC_STATS.  The value of XSTAT_REQUEST__EXTENDED_STATS may
> (AFAIK) change in the kernel in the future as the struct xstat gets more
> fields, unless that is not the intention.  The other option would be to
> rename this mask XSTAT_REQUEST__BASIC_XSTATS to indicate it represents
> (forever) all of the fields in the original struct xstat.

This is reasonable.  I've made that change.  I've also fixed the commit message
to not mention XSTAT_REQUEST__GET_ANYWAY anymore.

> > +int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> > {
> > +
> > +	stat->result_mask |= XSTAT_REQUEST_GEN | XSTAT_REQUEST_DATA_VERSION;
> > +	stat->gen = inode->i_generation;
> > +	stat->data_version = inode->i_version;
> 
> You didn't update the field names in any of the kernel patches,

What do you mean?  That's the kstat struct, not the xstat struct being set in
your excerpt.  Certainly 'inode_version' has become 'gen' in it and
'result_mask' now appears.

> > @@ -994,6 +994,8 @@ int ecryptfs_getattr(struct vfsmount *mnt,
> > +	lower_stat.query_flags = stat->query_flags;
> > +	lower_stat.request_mask = stat->request_mask | XSTAT_REQUEST_BLOCKS;
> > 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
> > 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
> 
> 
> Likewise, this doesn't have the newer field names.

Doesn't it?  Where?

I'm unsure as to whether I should copy across the btime, data_version and gen
fields here.


> I also don't understand why this is adding in the XSTAT_REQUEST_BLOCKS mask
> when that isn't requested by the caller?

Because it is wanted by ecryptfs_getattr:

 		stat->blocks = lower_stat.blocks;

though possibly this should be contingent on XSTAT_REQUEST_BLOCKS being set in
stat->request_mask.

> > int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> > {
> > +	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
> > +					    XSTAT_REQUEST_CTIME |
> > +					    XSTAT_REQUEST_DATA_VERSION
> > +					    )) &&
> > +	    S_ISREG(inode->i_mode)
> > +	    ) {
> 
> Minor nit - the parenthesis placement here looks decidedly unLinuxy.  Normally I think it should look like:

It makes it easier to see that the S_ISREG is part of the if-condition and not
part of the body.

David
