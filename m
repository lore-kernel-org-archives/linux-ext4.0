From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Mon, 02 Jul 2007 10:58:33 -0400
Message-ID: <1183388313.3864.35.camel@localhost.localdomain>
References: <1183275424.4010.126.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: linux-fsdevel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	"J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275424.4010.126.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Trond or Bruce, can you please review these patch series and ack if you
agrees? Thanks.

As to performance concerns that raise before the inode version counter
(at least for ext4) is done inside ext4_mark_inode_dirty), so there is
no extra IO work to store this counter to disk.

Mingming
On Sun, 2007-07-01 at 03:37 -0400, Mingming Cao wrote:
> This patch converts the 32-bit i_version in the generic inode to a 64-bit
> i_version field.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> 
> Index: linux-2.6.21/include/linux/fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/fs.h
> +++ linux-2.6.21/include/linux/fs.h
> @@ -549,7 +549,7 @@ struct inode {
>  	uid_t			i_uid;
>  	gid_t			i_gid;
>  	dev_t			i_rdev;
> -	unsigned long		i_version;
> +	u64			i_version;
>  	loff_t			i_size;
>  #ifdef __NEED_I_SIZE_ORDERED
>  	seqcount_t		i_size_seqcount;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

