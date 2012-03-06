From: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int
 may_flags' in nfsd_open()
Date: Mon, 5 Mar 2012 19:08:37 -0500
Message-ID: <20120306000837.GA17164@thunk.org>
References: <20120109132158.2616029.30467.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120109132158.2616029.30467.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
 <20120109132153.2616029.26302.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 09, 2012 at 02:21:53PM +0100, Bernd Schubert wrote:
> Just rename this variable, as the next patch will add a flag and
> 'access' as variable name would not be correct any more.
> 
> Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> Acked-by: J. Bruce Fields<bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nfsd/vfs.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)

On Mon, Jan 09, 2012 at 02:21:58PM +0100, Bernd Schubert wrote:
> Use 32-bit or 64-bit llseek() hashes for directory offsets depending on
> the NFS version. NFSv2 gets 32-bit hashes only.
> 
> NOTE: This patch got rather complex as Christoph asked to set the
> filp->f_mode flag in the open call or immediatly after dentry_open()
> in nfsd_open() to avoid races.
> Personally I still do not see a reason for that and in my opinion
> FMODE_32BITHASH/FMODE_64BITHASH flags could be set nfsd_readdir(), as it
> follows directly after nfsd_open() without a chance of races.
> 
> Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> Acked-by: J. Bruce Fields<bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nfsd/vfs.c |   15 +++++++++++++--
>  fs/nfsd/vfs.h |    2 ++
>  2 files changed, 15 insertions(+), 2 deletions(-)

NFS folks,

Since Bruce has ack'ed these patches I assume it will be OK if I carry
them in the ext4 tree for merging?  (They depend on changes in ext4
found in the first two patches of these patch series.)

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
