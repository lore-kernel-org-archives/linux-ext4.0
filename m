From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 10/10 v1][RESEND] ext4: add two tracepoints in
 punching hole
Date: Fri, 27 Jul 2012 15:43:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207271540350.23525@vpn-10-43.rdu.redhat.com>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com> <1342943986-12413-11-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab2G0Nn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2012 09:43:56 -0400
In-Reply-To: <1342943986-12413-11-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 22 Jul 2012, Zheng Liu wrote:

> Date: Sun, 22 Jul 2012 15:59:46 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com, wenqing.lz@taobao.com
> Subject: [RFC][PATCH 10/10 v1][RESEND] ext4: add two tracepoints in punching
>     hole
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This patch adds two tracepoints in ext4_ext_punch_hole.

Hi,

the trace_ext4_ext_punch_hole_enter() looks good, but I am not so
sure about the trace_ext4_ext_punch_hole_exit() trace point. What is
the point of having this tracepoint ? The only thing it adds to the
information we already have is return value of the function and
that's something we'll know anyway, right ?

Is there any special reason for having this ? If not, I think it can
be removed and trace_ext4_ext_punch_hole_enter() can be renamed to
trace_ext4_ext_punch_hole() to match the naming conventions of other
ext4 tracepoints.

Thanks!
-Lukas

> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents.c           |    3 ++
>  include/trace/events/ext4.h |   53 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 2a526b4..0fb4ff5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4529,6 +4529,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	loff_t first_page_offset, last_page_offset;
>  	int credits, err = 0;
>  
> +	trace_ext4_ext_punch_hole_enter(inode, offset, length);
> +
>  	mutex_lock(&inode->i_mutex);
>  
>  	/* No need to punch hole beyond i_size */
> @@ -4663,6 +4665,7 @@ out:
>  	ext4_journal_stop(handle);
>  error:
>  	mutex_unlock(&inode->i_mutex);
> +	trace_ext4_ext_punch_hole_exit(inode, offset, length, err);
>  	return err;
>  }
>  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 5c17592..583f066 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -1312,6 +1312,59 @@ TRACE_EVENT(ext4_fallocate_exit,
>  		  __entry->ret)
>  );
>  
> +TRACE_EVENT(ext4_ext_punch_hole_enter,
> +	TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
> +
> +	TP_ARGS(inode, offset, len),
> +
> +	TP_STRUCT__entry(
> +		__field(	dev_t,	dev			)
> +		__field(	ino_t,	ino			)
> +		__field(	loff_t,	offset			)
> +		__field(	loff_t, len			)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->offset	= offset;
> +		__entry->len	= len;
> +	),
> +
> +	TP_printk("dev %d,%d ino %lu offset %lld len %lld",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  (unsigned long) __entry->ino,
> +		  __entry->offset, __entry->len)
> +);
> +
> +TRACE_EVENT(ext4_ext_punch_hole_exit,
> +	TP_PROTO(struct inode *inode, loff_t offset,
> +		 loff_t len, int err),
> +
> +	TP_ARGS(inode, offset, len, err),
> +
> +	TP_STRUCT__entry(
> +		__field(	dev_t,	dev			)
> +		__field(	ino_t,	ino			)
> +		__field(	loff_t,	offset			)
> +		__field(	loff_t,	len			)
> +		__field(	int,	err			)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->offset	= offset;
> +		__entry->len	= len;
> +		__entry->err	= err;
> +	),
> +
> +	TP_printk("dev %d,%d ino %lu offset %lld len %lld err %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  (unsigned long) __entry->ino,
> +		  __entry->offset, __entry->len, __entry->err)
> +);
> +
>  TRACE_EVENT(ext4_unlink_enter,
>  	TP_PROTO(struct inode *parent, struct dentry *dentry),
>  
> 
