From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v3 12/13] vfs: add debugfs support
Date: Wed, 10 Oct 2012 18:53:18 +0200
Message-ID: <20121010165318.GA4405@twin.jikos.cz>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46086 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab2JJQxj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2012 12:53:39 -0400
Content-Disposition: inline
In-Reply-To: <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2012 at 06:07:34PM +0800, zwu.kernel@gmail.com wrote:
> +static int hot_debugfs_log_init(struct debugfs_vol_data *data)
> +{
> +	int err = 0;
> +	struct lstring *debugfs_log = data->debugfs_log;
> +
> +	spin_lock(&data->log_lock);
> +	debugfs_log->str = vmalloc(INIT_LOG_ALLOC_SIZE);

vmalloc __might_sleep(), do the allocation outside of the lock and assign
the value inside. Also, you may use vzalloc and drop the following memset.

dmesg:

vfs: turning on hot data tracking
BUG: sleeping function called from invalid context at mm/slab.c:3220
in_atomic(): 1, irqs_disabled(): 0, pid: 3103, name: mc
1 lock held by mc/3103:
 #0:  (&(&inode_data->log_lock)->rlock){+.+.+.}, at: [<ffffffff8118c656>] __hot_debugfs_comm_read+0x216/0x280
Pid: 3103, comm: mc Tainted: G        W    3.6.0hottrack-default+ #208
Call Trace:
 [<ffffffff8108068c>] __might_sleep+0xfc/0x130
 [<ffffffff8114f7c1>] kmem_cache_alloc_trace+0xe1/0x270
 [<ffffffff81142005>] __get_vm_area_node+0x95/0x1a0
 [<ffffffff8108630f>] ? local_clock+0x6f/0x80
 [<ffffffff8118c660>] ? __hot_debugfs_comm_read+0x220/0x280
 [<ffffffff8114283d>] __vmalloc_node_range+0x6d/0x200
 [<ffffffff8118c660>] ? __hot_debugfs_comm_read+0x220/0x280
 [<ffffffff8118b810>] ? hot_debugfs_log+0xe0/0xe0
 [<ffffffff81142a05>] __vmalloc_node+0x35/0x40
 [<ffffffff8118c660>] ? __hot_debugfs_comm_read+0x220/0x280
 [<ffffffff81142bcc>] vmalloc+0x2c/0x30
 [<ffffffff8118c660>] __hot_debugfs_comm_read+0x220/0x280
 [<ffffffff8191fd58>] ? __do_page_fault+0x238/0x590
 [<ffffffff810ab825>] ? trace_hardirqs_on_caller+0x155/0x1d0
 [<ffffffff8138d01e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8118c6d5>] __hot_debugfs_inode_read+0x15/0x20
 [<ffffffff8115a19b>] vfs_read+0xcb/0x190
 [<ffffffff8115a2c2>] sys_read+0x62/0xb0
 [<ffffffff8138d01e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81924979>] system_call_fastpath+0x16/0x1b

> +	if (debugfs_log->str) {
> +		memset(debugfs_log->str, 0, INIT_LOG_ALLOC_SIZE);
> +		data->log_alloc_size = INIT_LOG_ALLOC_SIZE;
> +	} else {
> +		err = -ENOMEM;
> +	}
> +	spin_unlock(&data->log_lock);
> +
> +	return err;
> +}

I'm now playing with it, and haven't gone through the code yet,
david
