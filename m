From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v3 12/13] vfs: add debugfs support
Date: Mon, 15 Oct 2012 19:04:27 +1100
Message-ID: <20121015080427.GA2739@dastard>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 10, 2012 at 06:07:34PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
> volume that contains two files. The first, `inode_data', contains the
> heat information for inodes that have been brought into the hot data map
> structures. The second, `range_data', contains similar information for
> subfile ranges.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/hot_tracking.c |  462 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/hot_tracking.h |   43 +++++
>  2 files changed, 505 insertions(+), 0 deletions(-)
.....
> +static int hot_debugfs_copy(struct debugfs_vol_data *data, char *msg, int len)
> +{
> +	struct lstring *debugfs_log = data->debugfs_log;
> +	uint new_log_alloc_size;
> +	char *new_log;
> +	static char err_msg[] = "No more memory!\n";
> +
> +	if (len >= data->log_alloc_size - debugfs_log->len) {
......
> +	}
> +
> +	memcpy(debugfs_log->str + debugfs_log->len, data->log_work_buff, len);
> +	debugfs_log->len += (unsigned long) len;
> +
> +	return len;
> +}
> +
> +/* Returns the number of bytes written to the log. */
> +static int hot_debugfs_log(struct debugfs_vol_data *data, const char *fmt, ...)
> +{
> +	struct lstring *debugfs_log = data->debugfs_log;
> +	va_list args;
> +	int len;
> +	static char trunc_msg[] =
> +			"The next message has been truncated.\n";
> +
> +	if (debugfs_log->str == NULL)
> +		return -1;
> +
> +	spin_lock(&data->log_lock);
> +
> +	va_start(args, fmt);
> +	len = vsnprintf(data->log_work_buff,
> +			sizeof(data->log_work_buff), fmt, args);
> +	va_end(args);
> +
> +	if (len >= sizeof(data->log_work_buff)) {
> +		hot_debugfs_copy(data, trunc_msg, sizeof(trunc_msg));
> +	}
> +
> +	len = hot_debugfs_copy(data, data->log_work_buff, len);
> +	spin_unlock(&data->log_lock);
> +
> +	return len;
> +}

Aren't you just recreating seq_printf() here? i.e. can't you replace
all this complexity with generic seq_file/seq_operations constructs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
