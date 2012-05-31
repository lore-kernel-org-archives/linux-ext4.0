From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 04/12] container quota: introduce container disk quota
 data header file.
Date: Thu, 31 May 2012 13:10:58 +0400
Message-ID: <4FC735A2.4040400@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com> <1338389946-13711-5-git-send-email-jeff.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
	<jack@suse.cz>, <daniel.lezcano@free.fr>, <tytso@mit.edu>,
	<bpm@sgi.com>, <chris.mason@oracle.com>, <hch@infradead.org>,
	<christopher.jones@oracle.com>, <david@fromorbit.com>,
	<tinguely@sgi.com>, <tm@tao.ma>, <linux-ext4@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
To: <jeff.liu@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1338389946-13711-5-git-send-email-jeff.liu@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> +
> +/* Operations for quota control */
> +struct ns_quotactl_ops {
> +	int (*quota_on)(struct mnt_namespace *, int);
> +	int (*quota_off)(struct mnt_namespace *, int);
> +	int (*get_info)(struct mnt_namespace *, int, struct if_dqinfo *);
> +	int (*set_info)(struct mnt_namespace *, int, struct if_dqinfo *);
> +	int (*get_dqblk)(struct mnt_namespace *, int, qid_t,
> +			 struct fs_disk_quota *);
> +	int (*set_dqblk)(struct mnt_namespace *, int, qid_t,
> +			 struct fs_disk_quota *);
> +};
> +

That is quite bad. Just have the same signature. Which namespace you 
belong to can *always* be derived from the calling process, you should 
never need to specify that in any interface. It is of course fine to do 
that in functions internal to the kernel, but not this.

You should rethink the whole ns_quota thing. Some of it I believe will 
have to stay, I doubt we'll be able to be completely transparent. But 
the core of your changes have to be making sure a hierarchical walk over 
the valid quotas work well, finding out what are those valid quotas, etc.

The interface should be kept as unchanged as possible, and this can be 
achieved by things like automatic discover of the current namespace, and 
pre-operational container setup for the relevant files.

