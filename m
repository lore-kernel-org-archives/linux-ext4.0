From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Is e2fsprogs-lustre_ismounted.patch actually needed?
Date: Wed, 11 Oct 2006 15:26:44 -0600
Message-ID: <20061011212644.GU22010@schatzie.adilger.int>
References: <E1GWefa-0000r5-L8@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:35805 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161413AbWJKV0s
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 17:26:48 -0400
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <E1GWefa-0000r5-L8@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 08, 2006  15:50 -0400, Theodore Ts'o wrote:
> So I started reworking it so it would be acceptable, and
> then I realized it defined two new static functions, neither of which
> were actually used in the patch.

Correct, my initial testing was on 2.6, which as you say works OK, but
we still have some customers (sadly) running 2.4 kernels where O_EXCL
doesn't work.

> 	If for some reason there is a good reason why Lustre isn't
> marking the device as busy, then we can look at the attached patch, but
> hopefully it isn't required at all.
> 
> +static errcode_t check_if_lustre_busy(const char *devname, int *mount_flags)
> +{
> +	procname = "/proc/fs/lustre/obdfilter";
> +	dirp = opendir(procname);
> +	if (!dirp) {
> +		procname = "/proc/fs/lustre/mds";
> +		dirp = opendir(procname);
> +	}

This isn't quite correct, compared to the earlier patch that calls
check_lustre_proc_vals() twice.  Lustre uses filesystems as either a
metadata target or storage target, and more than one of each can exist
on the same node (though usually they don't for large systems).  That
means this function needs to always check both the .../obdfilter tree
and the .../mds tree on a given node.  The above code will skip the
.../mds tree if the .../obdfilter tree exists.

> +		if (strcmp(real_devname, real_mnt_device) == 0) {
> +#ifdef DEBUG
> +			fprintf(stderr,
> +				"device %s mounted by lustre per %s\n",
> +				real_devname, proc_val);
> +#endif

The reason this was printed is that Lustre mounts (done internally
by the kernel) do not show up in /proc/mounts, or this whole exercise
wouldn't be needed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

