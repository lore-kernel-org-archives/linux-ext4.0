From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Mon, 19 May 2008 21:57:12 -0600
Message-ID: <20080520035712.GA7252@webber.adilger.int>
References: <20080514170625t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20080514170625t-sato@mail.jp.nec.com>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 14, 2008  17:06 +0900, Takashi Sato wrote:
> +static int ioctl_freeze(struct file *filp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* If filesystem doesn't support freeze feature, return. */
> +	if (sb->s_op->write_super_lockfs == NULL)
> +		return -EINVAL;

Should this be EINVAL, or EOPNOTSUPP?  Usually EINVAL means there is
something wrong with the passed ioctl parameters (e.g. bad value),
while EOPNOTSUPP is "operation not supported" and makes more sense.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

