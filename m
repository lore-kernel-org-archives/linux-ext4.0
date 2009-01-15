From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RESEND] [PATCH] lseek: change i_mutex usage.
Date: Thu, 15 Jan 2009 06:22:52 -0700
Message-ID: <20090115132252.GZ29283@parisc-linux.org>
References: <6.0.0.20.2.20090115163853.07056ed0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40177 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZAONXJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Jan 2009 08:23:09 -0500
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090115163853.07056ed0@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 15, 2009 at 04:42:19PM +0900, Hisashi Hifumi wrote:
> I changed i_mutex usage on generic_file_llseek.
> This function is inside i_mutex, but I think there is room for optimization in some cases.
> When SEEK_END is specified from caller, in this case we should handle
> inode->i_size so i_mutex is needed. But in other cases such as SEEK_CUR or
> SEEK_SET, i_mutex is not needed because just changing file->f_pos value without
> touching i_size.

Of course if you have multiple threads, they will share a struct file,
and you're updating f_pos and f_version without locking.  Maybe that's
OK, but it's soemthing you didn't discuss.

I think it's the only reason to have the mutex here.  Otherwise we could
simply use i_size_read() in generic_file_llseek_unlocked() and there
would be no need for a mutex at all.

> -	mutex_lock(&file->f_dentry->d_inode->i_mutex);
> -	rval = generic_file_llseek_unlocked(file, offset, origin);
> -	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
> +	if (origin == SEEK_END) {
> +		mutex_lock(&file->f_dentry->d_inode->i_mutex);
> +		rval = generic_file_llseek_unlocked(file, offset, origin);
> +		mutex_unlock(&file->f_dentry->d_inode->i_mutex);
> +	} else
> +		rval = generic_file_llseek_unlocked(file, offset, origin);

I'm pretty sure the spinning mutex work will have a significant effect
on the performance here.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
