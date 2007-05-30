From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [patch 0/2] i_version update
Date: Wed, 30 May 2007 16:32:57 -0700
Message-ID: <1180567978.3794.28.camel@dyn9047017103.beaverton.ibm.com>
References: <46570DFB.3080101@bull.net>  <20070530002100.GV85884050@sgi.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: David Chinner <dgc@sgi.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20070530002100.GV85884050@sgi.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-05-30 at 10:21 +1000, David Chinner wrote:
> On Fri, May 25, 2007 at 06:25:31PM +0200, Jean noel Cordenner wrote:
> > Hi,
> > 
> > This is an update of the i_version patch.
> > The i_version field is a 64bit counter that is set on every inode
> > creation and that is incremented every time the inode data is modified
> > (similarly to the "ctime" time-stamp).
> 
> My understanding (please correct me if I'm wrong) is that the
> requirements are much more rigourous than simply incrementing an in
> memory counter on every change.  i.e. the this counter has to
> survive server crashes intact so clients never see the counter go
> backwards. That means version number changes need to be journalled
> along with the operation that caused the change of the version
> number.
> 
Yeah, the i_version is the in memeory counter. From the patch it looks
like the counter is being updated inside ext4_mark_iloc_dirty(), so it
is being journalled and being flush to on-disk ext4 inode structure
immediately (On-disk ext4 inode structure is being modified/expanded to
store the counter in the first patch). 

>This patch is on top of i_version_update_vfs.
> The i_version field of the inode is set on inode creation and incremented when
> the inode is being modified.
> 
> Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> 
> Index: linux-2.6.22-rc2-ext4-1/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.22-rc2-ext4-1.orig/fs/ext4/ialloc.c	2007-05-25 18:05:28.000000000 +0200
> +++ linux-2.6.22-rc2-ext4-1/fs/ext4/ialloc.c	2007-05-25 18:05:40.000000000 +0200
> @@ -565,6 +565,7 @@
>  	inode->i_blocks = 0;
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
>  						       ext4_current_time(inode);
> +	inode->i_version = 1;
> 
>  	memset(ei->i_data, 0, sizeof(ei->i_data));
>  	ei->i_dir_start_lookup = 0;
> Index: linux-2.6.22-rc2-ext4-1/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.22-rc2-ext4-1.orig/fs/ext4/inode.c	2007-05-25 18:05:28.000000000 +0200
> +++ linux-2.6.22-rc2-ext4-1/fs/ext4/inode.c	2007-05-25 18:05:40.000000000 +0200
> @@ -3082,6 +3082,7 @@
>  {
>  	int err = 0;
> 
> +	inode->i_version++;
>  	/* the do_update_inode consumes one bh->b_count */
>  	get_bh(iloc->bh);
> 
> Index: linux-2.6.22-rc2-ext4-1/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc2-ext4-1.orig/fs/ext4/super.c	2007-05-25 18:05:28.000000000 +0200
> +++ linux-2.6.22-rc2-ext4-1/fs/ext4/super.c	2007-05-25 18:05:40.000000000 +0200
> @@ -2839,8 +2839,8 @@
>  		i_size_write(inode, off+len-towrite);
>  		EXT4_I(inode)->i_disksize = inode->i_size;
>  	}
> -	inode->i_version++;
>  	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_version = 1;
>  	ext4_mark_inode_dirty(handle, inode);
>  	mutex_unlock(&inode->i_mutex);
>  	return len - towrite;

I am not very clear about this part -- what is i_version being used for
with quota? And shall we reset the counter to 1 for ext4_quota_write()? 

Mingming
