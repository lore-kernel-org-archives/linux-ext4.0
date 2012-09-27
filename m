From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 04/10] vfs: add init and exit support
Date: Thu, 27 Sep 2012 12:27:51 +1000
Message-ID: <20120927022751.GL15236@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-5-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21765 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461Ab2I0C2F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 22:28:05 -0400
Content-Disposition: inline
In-Reply-To: <1348404995-14372-5-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 23, 2012 at 08:56:29PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Add initialization function to create some
> key data structures when hot tracking is enabled;
> Clean up them when hot tracking is disabled
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/hot_tracking.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/hot_tracking.h |    2 +
>  fs/namespace.c    |    4 +++
>  fs/super.c        |    6 +++++
>  4 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
> index f97e8a6..fa89f70 100644
> --- a/fs/hot_tracking.c
> +++ b/fs/hot_tracking.c
> @@ -135,6 +135,51 @@ static void hot_rb_free_hot_range_item(struct hot_range_item *hr)
>  	}
>  }
>  
> +static int hot_rb_remove_hot_inode_item(struct hot_inode_tree *tree,
> +                                struct hot_inode_item *he)

hot_inode_item_remove()

> +{
> +        int ret = 0;
> +        rb_erase(&he->rb_node, &tree->map);
> +        he->in_tree = 0;
> +        return ret;
> +}
> +
> +static int hot_rb_remove_hot_range_item(struct hot_range_tree *tree,
> +                                struct hot_range_item *hr)

hot_range_item_remove()

(repeat for other function names ;)

> +{
> +        int ret = 0;
> +        rb_erase(&hr->rb_node, &tree->map);
> +        hr->in_tree = 0;
> +        return ret;
> +}

these can probably be void functions are they don't use the return
value at all.

> +
> +/* Frees the entire hot_inode_tree. */
> +static void hot_rb_inode_tree_free(struct hot_info *root)
> +{
> +	struct rb_node *node, *node2;
> +	struct hot_inode_item *he;
> +	struct hot_range_item *hr;
> +
> +	/* Free hot inode and range trees on fs root */
> +	node = rb_first(&root->hot_inode_tree.map);
> +
> +	while (node) {

	while ((node = rb_first(&root->hot_inode_tree.map))) {

> +		he = rb_entry(node, struct hot_inode_item, rb_node);
> +
> +		node2 = rb_first(&he->hot_range_tree.map);
> +		while (node2) {

		while ((node2 = rb_first(&he->hot_range_tree.map))) {

.....
>  
> +	if (sb->s_hotinfo.mount_opt & HOT_MOUNT_HOT_TRACK)
> +		hot_track_exit(sb);
> +

Let the filesystems call in .put_super()

>  	down_write(&namespace_sem);
>  	br_write_lock(&vfsmount_lock);
>  	event++;
> diff --git a/fs/super.c b/fs/super.c
> index 7eb3b0c..0999d5c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1153,6 +1153,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
>  	WARN_ON(sb->s_bdi == &default_backing_dev_info);
>  	sb->s_flags |= MS_BORN;
>  
> +	if (hottrack)
> +		hot_track_init(sb, name);

And call this in .fill_super() after parsing the hottrack argument.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
