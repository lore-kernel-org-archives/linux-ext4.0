Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48662 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbeKOPy5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 10:54:57 -0500
Subject: Re: [PATCH v2] jbd2: add proc entry to control whethre doing buffer
 copy-out
To: linux-ext4@vger.kernel.org
References: <050b7290-ed29-26e7-e52f-e83ee46dafb9@linux.alibaba.com>
 <20181115054111.47229-1-xiaoguang.wang@linux.alibaba.com>
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <85d52b4f-6bd9-8f91-0a13-f368926f807f@linux.alibaba.com>
Date: Thu, 15 Nov 2018 13:46:46 +0800
MIME-Version: 1.0
In-Reply-To: <20181115054111.47229-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

Sorry, you can ignore this patch, this fixing method maybe not good.

Regards,
Xiaoguang Wang
> When jbd2 tries to get write access to one buffer, and if this buffer
> is under writeback with BH_Shadow flag, jbd2 will wait until this buffer
> has been written to disk, but sometimes the time taken to wait may be
> much long, especially disk capacity is almost full.
> 
> Here add a proc entry "force-copy", if its value is not zero, jbd2 will
> always do meta buffer copy-cout, then we can eliminate the unnecessary
> wating time here, and reduce long tail latency for buffered-write.
> 
> I construct such test case below:
> 
> $cat offline.fio
> ; fio-rand-RW.job for fiotest
> 
> [global]
> name=fio-rand-RW
> filename=fio-rand-RW
> rw=randrw
> rwmixread=60
> rwmixwrite=40
> bs=4K
> direct=0
> numjobs=4
> time_based=1
> runtime=900
> 
> [file1]
> size=60G
> ioengine=sync
> iodepth=16
> 
> $cat online.fio
> ; fio-seq-write.job for fiotest
> 
> [global]
> name=fio-seq-write
> filename=fio-seq-write
> rw=write
> bs=256K
> direct=0
> numjobs=1
> time_based=1
> runtime=60
> 
> [file1]
> rate=50m
> size=10G
> ioengine=sync
> iodepth=16
> 
> With this patch:
> $cat /proc/fs/jbd2/sda5-8/force_copy
> 0
> 
> online fio almost always get such long tail latency:
> 
> Jobs: 1 (f=1), 0B/s-0B/s: [W(1)][100.0%][w=50.0MiB/s][w=200 IOPS][eta
> 00m:00s]
> file1: (groupid=0, jobs=1): err= 0: pid=17855: Thu Nov 15 09:45:57 2018
>    write: IOPS=200, BW=50.0MiB/s (52.4MB/s)(3000MiB/60001msec)
>      clat (usec): min=135, max=4086.6k, avg=867.21, stdev=50338.22
>       lat (usec): min=139, max=4086.6k, avg=871.16, stdev=50338.22
>      clat percentiles (usec):
>       |  1.00th=[    141],  5.00th=[    143], 10.00th=[    145],
>       | 20.00th=[    147], 30.00th=[    147], 40.00th=[    149],
>       | 50.00th=[    149], 60.00th=[    151], 70.00th=[    153],
>       | 80.00th=[    155], 90.00th=[    159], 95.00th=[    163],
>       | 99.00th=[    255], 99.50th=[    273], 99.90th=[    429],
>       | 99.95th=[    441], 99.99th=[3640656]
> 
> $cat /proc/fs/jbd2/sda5-8/force_copy
> 1
> 
> online fio latency is much better.
> 
> Jobs: 1 (f=1), 0B/s-0B/s: [W(1)][100.0%][w=50.0MiB/s][w=200 IOPS][eta
> 00m:00s]
> file1: (groupid=0, jobs=1): err= 0: pid=8084: Thu Nov 15 09:31:15 2018
>    write: IOPS=200, BW=50.0MiB/s (52.4MB/s)(3000MiB/60001msec)
>      clat (usec): min=137, max=545, avg=151.35, stdev=16.22
>       lat (usec): min=140, max=548, avg=155.31, stdev=16.65
>      clat percentiles (usec):
>       |  1.00th=[  143],  5.00th=[  145], 10.00th=[  145], 20.00th=[
> 147],
>       | 30.00th=[  147], 40.00th=[  147], 50.00th=[  149], 60.00th=[
> 149],
>       | 70.00th=[  151], 80.00th=[  155], 90.00th=[  157], 95.00th=[
> 161],
>       | 99.00th=[  239], 99.50th=[  269], 99.90th=[  420], 99.95th=[
> 429],
>       | 99.99th=[  537]
> 
> As to the cost: because we'll always need to copy meta buffer, will
> consume minor cpu time and some memory(at most 32MB for 128MB journal
> size).
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> v2:
>      add missing "force-copy" directory delete operation
> ---
>   fs/jbd2/journal.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/jbd2.h |  5 +++++
>   2 files changed, 63 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8ef6b6daaa7a..7fdaf501610a 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -418,6 +418,9 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>   	}
>   	kunmap_atomic(mapped_data);
>   
> +	/* force copy-out */
> +	if (need_copy_out == 0 && journal->j_force_copy)
> +		need_copy_out = 1;
>   	/*
>   	 * Do we need to do a data copy?
>   	 */
> @@ -1100,6 +1103,58 @@ static const struct file_operations jbd2_seq_info_fops = {
>   	.release        = jbd2_seq_info_release,
>   };
>   
> +static int jbd2_seq_force_copy_show(struct seq_file *m, void *v)
> +{
> +	journal_t *journal = m->private;
> +
> +	seq_printf(m, "%u\n", journal->j_force_copy);
> +	return 0;
> +}
> +
> +static int jbd2_seq_force_copy_open(struct inode *inode, struct file *filp)
> +{
> +	journal_t *journal = PDE_DATA(inode);
> +
> +	return single_open(filp, jbd2_seq_force_copy_show, journal);
> +}
> +
> +/* Worst case buffer size needed for holding an integer. */
> +#define PROC_NUMBUF 13
> +
> +static ssize_t jbd2_seq_force_copy_write(struct file *file,
> +			const char __user *buf, size_t count, loff_t *offset)
> +{
> +	struct inode *inode = file_inode(file);
> +	journal_t *journal = PDE_DATA(inode);
> +	char buffer[PROC_NUMBUF];
> +	unsigned int force_copy;
> +	int err;
> +
> +	memset(buffer, 0, sizeof(buffer));
> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;
> +	if (copy_from_user(buffer, buf, count)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +
> +	err = kstrtouint(strstrip(buffer), 0, &force_copy);
> +	if (err)
> +		goto out;
> +	journal->j_force_copy = force_copy;
> +out:
> +	return err < 0 ? err : count;
> +}
> +
> +static const struct file_operations jbd2_seq_force_copy_fops = {
> +	.owner		= THIS_MODULE,
> +	.open           = jbd2_seq_force_copy_open,
> +	.read           = seq_read,
> +	.write		= jbd2_seq_force_copy_write,
> +	.llseek         = seq_lseek,
> +	.release        = single_release,
> +};
> +
>   static struct proc_dir_entry *proc_jbd2_stats;
>   
>   static void jbd2_stats_proc_init(journal_t *journal)
> @@ -1108,12 +1163,15 @@ static void jbd2_stats_proc_init(journal_t *journal)
>   	if (journal->j_proc_entry) {
>   		proc_create_data("info", S_IRUGO, journal->j_proc_entry,
>   				 &jbd2_seq_info_fops, journal);
> +		proc_create_data("force_copy", 0644, journal->j_proc_entry,
> +				 &jbd2_seq_force_copy_fops, journal);
>   	}
>   }
>   
>   static void jbd2_stats_proc_exit(journal_t *journal)
>   {
>   	remove_proc_entry("info", journal->j_proc_entry);
> +	remove_proc_entry("force_copy", journal->j_proc_entry);
>   	remove_proc_entry(journal->j_devname, proc_jbd2_stats);
>   }
>   
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index b708e5169d1d..7034888eac6b 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1111,6 +1111,11 @@ struct journal_s
>   	 */
>   	struct transaction_stats_s j_stats;
>   
> +	/**
> +	 * @j_force_copy: if not zero, force to do buffer copy-out.
> +	 */
> +	unsigned int j_force_copy;
> +
>   	/**
>   	 * @j_failed_commit: Failed journal commit ID.
>   	 */
> 
