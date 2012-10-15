From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 12/13] vfs: add debugfs support
Date: Mon, 15 Oct 2012 16:47:51 +0800
Message-ID: <CAEH94LhP02Z2kLi-HfpoiL8=tHWuCZ-cWt7VR3TznFj+wpQ-gQ@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
	<20121015080427.GA2739@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45298 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2JOIrx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2012 04:47:53 -0400
In-Reply-To: <20121015080427.GA2739@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 4:04 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 10, 2012 at 06:07:34PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
>> volume that contains two files. The first, `inode_data', contains the
>> heat information for inodes that have been brought into the hot data map
>> structures. The second, `range_data', contains similar information for
>> subfile ranges.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/hot_tracking.c |  462 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/hot_tracking.h |   43 +++++
>>  2 files changed, 505 insertions(+), 0 deletions(-)
> .....
>> +static int hot_debugfs_copy(struct debugfs_vol_data *data, char *msg, int len)
>> +{
>> +     struct lstring *debugfs_log = data->debugfs_log;
>> +     uint new_log_alloc_size;
>> +     char *new_log;
>> +     static char err_msg[] = "No more memory!\n";
>> +
>> +     if (len >= data->log_alloc_size - debugfs_log->len) {
> ......
>> +     }
>> +
>> +     memcpy(debugfs_log->str + debugfs_log->len, data->log_work_buff, len);
>> +     debugfs_log->len += (unsigned long) len;
>> +
>> +     return len;
>> +}
>> +
>> +/* Returns the number of bytes written to the log. */
>> +static int hot_debugfs_log(struct debugfs_vol_data *data, const char *fmt, ...)
>> +{
>> +     struct lstring *debugfs_log = data->debugfs_log;
>> +     va_list args;
>> +     int len;
>> +     static char trunc_msg[] =
>> +                     "The next message has been truncated.\n";
>> +
>> +     if (debugfs_log->str == NULL)
>> +             return -1;
>> +
>> +     spin_lock(&data->log_lock);
>> +
>> +     va_start(args, fmt);
>> +     len = vsnprintf(data->log_work_buff,
>> +                     sizeof(data->log_work_buff), fmt, args);
>> +     va_end(args);
>> +
>> +     if (len >= sizeof(data->log_work_buff)) {
>> +             hot_debugfs_copy(data, trunc_msg, sizeof(trunc_msg));
>> +     }
>> +
>> +     len = hot_debugfs_copy(data, data->log_work_buff, len);
>> +     spin_unlock(&data->log_lock);
>> +
>> +     return len;
>> +}
>
> Aren't you just recreating seq_printf() here? i.e. can't you replace
> all this complexity with generic seq_file/seq_operations constructs?
It seems to be a good suggestion, let me try it. thanks.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
