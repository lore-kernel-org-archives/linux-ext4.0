From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V4] ext4: Fix lockdep recursive locking warning
Date: Sat, 22 Nov 2008 15:46:25 -0500
Message-ID: <20081122204625.GF9150@mit.edu>
References: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60383 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758102AbYKVXAr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Nov 2008 18:00:47 -0500
Content-Disposition: inline
In-Reply-To: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 10:10:46PM +0530, Aneesh Kumar K.V wrote:
> Indicate that the group locks can be taken in loop.

I've been looking at this patch more closely, and I think there's a
major problem here.  You've statically declared alloc_sem_key to be
NR_BG_LOCKS:

> +#ifdef CONFIG_LOCKDEP
> +static struct lock_class_key alloc_sem_key[NR_BG_LOCKS];
> +#endif

NR_BG_LOCKS is defined in include/linux/blockgroup_lock.h, and is 4 if
NR_CPUS is 1 or 2, 8 if NR_CPUS is 3, 16 if NR_CPUS is between 4 and
7, 32 if NR_CPUS is between 8 and 15, and so on.

It gets used this way:

> +#ifdef CONFIG_LOCKDEP
> +	__init_rwsem(&meta_group_info[i]->alloc_sem,
> +			"&meta_group_info[i]->alloc_sem",
> +			&alloc_sem_key[i]);

But i is set thusly:

    i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);

which means i is between 0 and 127 if the filesystem has block 4k
filesystem....

It's also not clear to me that this will do the right thing if there
are multiple ext4 filesystems mounted.  Since we are using a static
array for the lockdep class keys, that means that sb->s_group_info[x]
for one filesystem is considered in the same lockdep class as
sb->s_group_info[x] for another filesystem.  This could cause false
positives if there are multiple ext4 filesystems mounted and two CPU's
are simultaneously accessing the filesystems and then access the two
s_group_info structures in different orders.  Am I missing something?

	     		   	     	      	 - Ted

