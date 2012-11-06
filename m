From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v4+ hot_track 10/19] vfs: introduce hot func register
 framework
Date: Wed, 7 Nov 2012 00:14:47 +0100
Message-ID: <20121106231447.GV3102@twin.jikos.cz>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-11-git-send-email-zwu.kernel@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50166 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2KFXPI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 18:15:08 -0500
Content-Disposition: inline
In-Reply-To: <1351485061-12297-11-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 12:30:52PM +0800, zwu.kernel@gmail.com wrote:
> +static struct hot_func_type *hot_func_get(const char *name)
> +{
> +	struct hot_func_type *f, *h = &hot_func_def;
> +
> +	spin_lock(&hot_func_list_lock);
> +	list_for_each_entry(f, &hot_func_list, list) {
> +		if (!strcmp(f->hot_func_name, name))
> +			h = f;

You probably want to break here

> +	}
> +	spin_unlock(&hot_func_list_lock);
> +
> +	return h;
> +}
> +
> +int hot_func_register(struct hot_func_type *h)
> +{
> +	struct hot_func_type *f, *t = NULL;
> +
> +	/* register, don't allow duplicate names */
> +	spin_lock(&hot_func_list_lock);
> +	list_for_each_entry(f, &hot_func_list, list) {
> +		if (!strcmp(f->hot_func_name, h->hot_func_name))
> +			t = f;

if duplicate names are not allowed, then a warning may make sense to
let us know that something is wrong

> +	}
> +
> +	if (t) {
> +		spin_unlock(&hot_func_list_lock);
> +		return -EBUSY;
> +	}
> +
> +	list_add_tail(&h->list, &hot_func_list);
> +	spin_unlock(&hot_func_list_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hot_func_register);
> --- a/include/linux/hot_tracking.h
> +++ b/include/linux/hot_tracking.h
> @@ -73,6 +75,25 @@ struct hot_range_item {
>  	u32 len; /* length in bytes */
>  };
>  
> +typedef u64 (hot_rw_freq_calc_fn) (struct timespec old_atime,
> +			struct timespec cur_time, u64 old_avg);
> +typedef u32 (hot_temp_calc_fn) (struct hot_freq_data *freq_data);
> +typedef bool (hot_is_obsolete_fn) (struct hot_freq_data *freq_data);

I'm thinking, whether these typedefs are useful, similar ops structures
do not introduce them, also when you pick a struct member names exactly
same as the typedefs:

> +struct hot_func_ops {
> +	hot_rw_freq_calc_fn *hot_rw_freq_calc_fn;
> +	hot_temp_calc_fn *hot_temp_calc_fn;
> +	hot_is_obsolete_fn *hot_is_obsolete_fn;
> +};

My suggestion is to make the types explicit in the structure.

> +/* identifies an hot func type */
> +struct hot_func_type {
> +	char hot_func_name[HOT_NAME_MAX];

'name' would be sufficient IMHO

> +	/* fields provided by specific FS */
> +	struct hot_func_ops ops;
> +	struct list_head list;
> +};

david
