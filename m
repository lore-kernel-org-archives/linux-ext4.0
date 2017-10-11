From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Wed, 11 Oct 2017 19:11:03 +0800
Message-ID: <59DDFC47.3050300@cn.fujitsu.com>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com> <59C8D147.1060608@cn.fujitsu.com> <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com> <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com> <59D5DEE0.6080506@cn.fujitsu.com> <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com> <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com> <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com> <20171007032917.bntgnubthdstmrrt@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Amir Goldstein <amir73il@gmail.com>,
        Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52343 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752012AbdJKLLJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Oct 2017 07:11:09 -0400
In-Reply-To: <20171007032917.bntgnubthdstmrrt@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2017/10/07 11:29, Theodore Ts'o wrote:
> On Thu, Oct 05, 2017 at 07:34:10PM -0500, Ashlie Martinez wrote:
>>>> It almost seems that way, though to be honest, I don't think I know
>>>> enough about 1. the setup used by Amir and 2. all the internal working
>>>> of KVM+virtio to say for sure.
>>> I believe you misread my email.
>>> The problem was NOT reproduced on KVM+virtio.
>>> The problem *is* reproduced on a 10G LVM volume over SSD on
>>> Ubuntu 16.04 with latest kernel and latest e2fsprogs.
> I was able to reproduce it using both kvm-xfstests[1] and gce-xfstests[2].
>
> [1] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-xfstests.md
> [2] https://thunk.org/gce-xfstests
>
> It did turn out to be timing related, and it requires that a journal
> commit take place after fsstress runs, but it can *not* be triggered
> by a sync/fsync (as this would cause the delayed allocation writes to
> be forced out to disk, and that makes the problem go away).
>
> I initially tried using xfs_io as a replacement for fsstress (since it
> is more flexible and would allow me to more easily run experiments),
> but it turns out xfs_io was too fast/efficient, and so using xfs_io to
> execute the same system calls (verified by strace) would not replicate
> the problem.
>
>>> Now you have a broken file system image and the exact set of operations
>>> that led to it. That's should be a pretty big lead for investigation.
> It was indeed a big lead for investigation (thanks, Amir!), but it
> still took me several hours before I was finally able to figure out
> the problem.  The patch and the commit description should explain what
> was going on.
>
> I'll leave it to Ashlie and Vijay to investigate how to improve Crash
> Monkey so it can better find problems like this automatically.  Since
> you now have a clear reproducer (you can use generic/456 and run it on
> gce-xfstests, using is a standard cloud VM configuration) and an
> explanation of the bug and the four-line fix, I suspect this might be
> good grist for follow-on research after your Hot Storage '17 workshop
> paper.  :-)
>
> Best regards,
>
> 					- Ted
>
>
> commit 3912e7b44cf77e9452d4d0cb6c1da9c7043bb7f1
> Author: Theodore Ts'o<tytso@mit.edu>
> Date:   Fri Oct 6 23:09:55 2017 -0400
>
>      ext4: fix interaction between i_size, fallocate, and delalloc after a crash
Hi Theodore,

After applying your patch, generic/456 always passes on my system which 
just triggers the output[2].
So i could believe this two different outputs[1][2] are triggered by 
different environments, but they
are caused by the same bug which your patch fixes.  Is this right?

[1] Inode 12, end of extent exceeds allowed value(logical block 33, 
physical block 33441, len 7)Clear? no
       Inode 12, i_blocks is 184, should be 128. Fix? no
[2] Inode 12, i_size is 147456, should be 163840. Fix? no

Sorry, i am not familiar with ext4.

Thanks,
Xiao Yang
>
>      If there are pending writes subject to delayed allocation, then i_size
>      will show size after the writes have completed, while i_disksize
>      contains the value of i_size on the disk (since the writes have not
>      been persisted to disk).
>
>      If fallocate(2) is called with the FALLOC_FL_KEEP_SIZE flag, either
>      with or without the FALLOC_FL_ZERO_RANGE flag set, and the new size
>      after the fallocate(2) is between i_size and i_disksize, then after a
>      crash, if a journal commit has resulted in the changes made by the
>      fallocate() call to be persisted after a crash, but the delayed
>      allocation write has not resolved itself, i_size would not be updated,
>      and this would cause the following e2fsck complaint:
>
>      Inode 12, end of extent exceeds allowed value
>              (logical block 33, physical block 33441, len 7)
>
>      This can only take place on a sparse file, where the fallocate(2) call
>      is allocating blocks in a range which is before a pending delayed
>      allocation write which is extending i_size.  Since this situation is
>      quite rare, and the window in which the crash must take place is
>      typically<  30 seconds, in practice this condition will rarely happen.
>
>      Nevertheless, it can be triggered in testing, and in particular by
>      xfstests generic/456.
>
>      Signed-off-by: Theodore Ts'o<tytso@mit.edu>
>      Reported-by: Amir Goldstein<amir73il@gmail.com>
>      Cc: stable@vger.kernel.org
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 97f0fd06728d..07bca11749d4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4794,7 +4794,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>   	}
>
>   	if (!(mode&  FALLOC_FL_KEEP_SIZE)&&
> -	     offset + len>  i_size_read(inode)) {
> +	    (offset + len>  i_size_read(inode) ||
> +	     offset + len>  EXT4_I(inode)->i_disksize)) {
>   		new_size = offset + len;
>   		ret = inode_newsize_ok(inode, new_size);
>   		if (ret)
> @@ -4965,7 +4966,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>   	}
>
>   	if (!(mode&  FALLOC_FL_KEEP_SIZE)&&
> -	     offset + len>  i_size_read(inode)) {
> +	    (offset + len>  i_size_read(inode) ||
> +	     offset + len>  EXT4_I(inode)->i_disksize)) {
>   		new_size = offset + len;
>   		ret = inode_newsize_ok(inode, new_size);
>   		if (ret)
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> .
>
