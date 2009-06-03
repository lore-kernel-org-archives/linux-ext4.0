From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] FS: filesystem corruption notification
Date: Wed, 3 Jun 2009 11:58:10 -0700
Message-ID: <20090603115810.10641330.akpm@linux-foundation.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbZFCS6p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 14:58:45 -0400
In-Reply-To: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed,  3 Jun 2009 18:05:15 +0300
Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:

> Add a generic mechnism to notify the userspace about possible filesystem
> corruption through sysfs entry (/sys/block/<bdev>/<part>/fs_unclean)
> and uevent (KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]).
> 
> To mark fs clean (e.g. after fs was fixed by userspace):
> 
> echo 0 > /sys/block/<bdev>/<part>/fs_unclean
> (you will still receive uevent KOBJ_CHANGE with env var FS_UNCLEAN=0)
> 
> Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
> ---
>  fs/partitions/check.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/genhd.h |    2 ++
>  2 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 99e33ef..191d89e 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -196,6 +196,24 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
>  	return ERR_PTR(res);
>  }
>  
> +void notify_part_fs_unclean(struct device *dev, uint8_t unclean)
> +{
> +	char event_string[13];
> +	char *envp[] = { event_string, NULL };
> +
> +	if ((unclean != 0 && unclean != 1) ||
> +		unclean == dev_to_part(dev)->fs_unclean)
> +		return;
> +
> +	dev_to_part(dev)->fs_unclean = unclean;
> +
> +	sysfs_notify(&dev->kobj, NULL, "fs_unclean");
> +
> +	sprintf(event_string, "FS_UNCLEAN=%u", unclean);
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +}
> +EXPORT_SYMBOL(notify_part_fs_unclean);

Please document this function.

That documentation should, amongst other things, explain the semantics
of the `unclean' argument.  It can be 0, 1 or "something else".  Why?

Also, why is `unclean' a u8 rather than a boring old `int'?

>  static ssize_t part_partition_show(struct device *dev,
>  				   struct device_attribute *attr, char *buf)
>  {
> @@ -246,6 +264,26 @@ ssize_t part_stat_show(struct device *dev,
>  		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
>  }
>  
> +ssize_t part_fs_unclean_show(struct device *dev,
> +		       struct device_attribute *attr, char *buf)
> +{
> +	struct hd_struct *p = dev_to_part(dev);
> +
> +	return sprintf(buf, "%d\n", p->fs_unclean);
> +}
> +
> +ssize_t part_fs_unclean_store(struct device *dev,
> +			struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	int i;
> +
> +	if (count > 0 && sscanf(buf, "%d", &i) > 0)

strict_strtoul(), please.

> +		notify_part_fs_unclean(dev, (i == 0) ? 0 : 1);
> +
> +	return count;
> +}

