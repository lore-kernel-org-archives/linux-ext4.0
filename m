From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 10 Jul 2007 16:30:38 -0700
Message-ID: <20070710163038.ceb2ae94.akpm@linux-foundation.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275424.4010.126.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:37:04 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch converts the 32-bit i_version in the generic inode to a 64-bit
> i_version field.
> 

That's obvious from the patch.  But what was the reason for making this
(unrelated to ext4) change?

Please update the changelog for this.

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

