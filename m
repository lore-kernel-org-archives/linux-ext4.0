From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v3 12/13] vfs: add debugfs support
Date: Wed, 10 Oct 2012 23:05:55 +0200
Message-ID: <20121010210555.GB4405@twin.jikos.cz>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 10, 2012 at 06:07:34PM +0800, zwu.kernel@gmail.com wrote:
> +static int hot_debugfs_copy(struct debugfs_vol_data *data, char *msg, int len)
> +{
> +	struct lstring *debugfs_log = data->debugfs_log;
> +	uint new_log_alloc_size;
> +	char *new_log;
> +	static char err_msg[] = "No more memory!\n";
> +
> +	if (len >= data->log_alloc_size - debugfs_log->len) {
> +		/*
> +		 * Not enough room in the log buffer for the new message.
> +		 * Allocate a bigger buffer.
> +		 */
> +		new_log_alloc_size = data->log_alloc_size + LOG_PAGE_SIZE;
> +		new_log = vmalloc(new_log_alloc_size);

This is also called with a spinlock from hot_debugfs_log, and it is a
frequent call. I found my testbox inaccessible after an hour of md5sums
on a partition when I tried to print contents of the /sys/debug files.

Serial console log filled with

[ 4886.141736] BUG: scheduling while atomic: mc/3176/0x00000004
[ 4886.148443] INFO: lockdep is turned off.
[ 4886.153424] Modules linked in: aoe dm_crypt loop btrfs
[ 4886.159705] Pid: 3176, comm: mc Tainted: G        W    3.6.0hottrack-default+ #209
[ 4886.168346] Call Trace:
[ 4886.171842]  [<ffffffff8107e528>] __schedule_bug+0x68/0x90
[ 4886.178427]  [<ffffffff81919b6c>] __schedule+0x73c/0x810
[ 4886.184809]  [<ffffffff81919cf9>] schedule+0x29/0x70
[ 4886.190838]  [<ffffffff8191729c>] schedule_timeout+0x17c/0x2f0
[ 4886.197732]  [<ffffffff8105c260>] ? del_timer+0x100/0x100
[ 4886.204198]  [<ffffffff8191b59b>] ? _raw_spin_unlock+0x2b/0x50
[ 4886.211099]  [<ffffffff8191742e>] schedule_timeout_uninterruptible+0x1e/0x20
[ 4886.219211]  [<ffffffff811150a9>] __alloc_pages_nodemask+0x839/0x9f0
[ 4886.226624]  [<ffffffff811428c3>] __vmalloc_node_range+0xf3/0x200
[ 4886.233788]  [<ffffffff8118b659>] ? hot_debugfs_copy+0x59/0x130
[ 4886.240774]  [<ffffffff81142a05>] __vmalloc_node+0x35/0x40
[ 4886.247335]  [<ffffffff8118b659>] ? hot_debugfs_copy+0x59/0x130
[ 4886.254331]  [<ffffffff81142bcc>] vmalloc+0x2c/0x30
[ 4886.260299]  [<ffffffff8118b659>] hot_debugfs_copy+0x59/0x130
[ 4886.267130]  [<ffffffff8118b7c6>] hot_debugfs_log+0x96/0xe0
[ 4886.273772]  [<ffffffff8118b86f>] __hot_debugfs_print_inode_freq_data+0x5f/0x80
[ 4886.282149]  [<ffffffff8118c58c>] __hot_debugfs_comm_read+0x14c/0x280
[ 4886.289653]  [<ffffffff8118b810>] ? hot_debugfs_log+0xe0/0xe0
[ 4886.296461]  [<ffffffff8118c6d5>] __hot_debugfs_inode_read+0x15/0x20
[ 4886.303853]  [<ffffffff8115a19b>] vfs_read+0xcb/0x190
[ 4886.309934]  [<ffffffff8115a2c2>] sys_read+0x62/0xb0
[ 4886.315927]  [<ffffffff8138d01e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 4886.323399]  [<ffffffff81924979>] system_call_fastpath+0x16/0x1b


david
