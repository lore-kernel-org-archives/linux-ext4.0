From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Save and restore state flags in EXT4_IOC_SETFLAGS.
Date: Mon, 04 Jun 2012 11:22:55 +0800
Message-ID: <4FCC2A0F.40804@tao.ma>
References: <1336145869-4120-1-git-send-email-tm@tao.ma> <20120601034820.GC7897@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, stable <stable@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43262 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755683Ab2FDDXL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jun 2012 23:23:11 -0400
In-Reply-To: <20120601034820.GC7897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	Sorry for the delay.
On 06/01/2012 11:48 AM, Ted Ts'o wrote:
> On Fri, May 04, 2012 at 11:37:49PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In commit 353eb83c we removes i_state_flags with 64-bit longs,
>> But in case we call EXT4_IOC_SETFLAGS, we fail to save the
>> high 32-bit state flags and only stores the low 32-bit back
>> to ei->i_flags. So the state flags are missing now in 64-bit
>> long architecture.
> 
> The problem with this approach is that we are still editing i_flags
> and then replacing it with the new value.  So we're vulnerable to
> races where some other process is modifies the i_state_flags between
> when we sample it using ext4_save_state_flags() and when we restore
> them.
> 
> This is a better way to fix the problem, and what I plan to commit
> into the ext4 tree:
> 
> commit 79906964a187c405db72a3abc60eb9b50d804fbc
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu May 31 23:46:01 2012 -0400
> 
>     ext4: don't trash state flags in EXT4_IOC_SETFLAGS
>     
>     In commit 353eb83c we removed i_state_flags with 64-bit longs, But
>     when handling the EXT4_IOC_SETFLAGS ioctl, we replace i_flags
>     directly, which trashes the state flags which are stored in the high
>     32-bits of i_flags on 64-bit platforms.  So use the the
>     ext4_{set,clear}_inode_flags() functions which use atomic bit
>     manipulation functions instead.
>     
>     Reported-by: Tao Ma <boyu.mt@taobao.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Cc: stable@kernel.org
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index feba55a..8ad112a 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -38,7 +38,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		handle_t *handle = NULL;
>  		int err, migrate = 0;
>  		struct ext4_iloc iloc;
> -		unsigned int oldflags;
> +		unsigned int oldflags, mask, i;
>  		unsigned int jflag;
>  
>  		if (!inode_owner_or_capable(inode))
> @@ -115,8 +115,14 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		if (err)
>  			goto flags_err;
>  
> -		flags = flags & EXT4_FL_USER_MODIFIABLE;
> -		flags |= oldflags & ~EXT4_FL_USER_MODIFIABLE;
> +		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
> +			if (!(mask & EXT4_FL_USER_MODIFIABLE))
> +				continue;
> +			if (mask & flags)
> +				ext4_set_inode_flag(inode, i);
> +			else
> +				ext4_clear_inode_flag(inode, i);
> +		}
>  		ei->i_flags = flags;
You forget to remove this line and we can still get the problem.

I am busy with other stuff and when I got to it, it is already in linus'
tree. So I have sent out another patch to remove this line and after
that my test case passed. The patch subject is "[PATCH] ext4: Don't set
i_flags in EXT4_IOC_SETFLAGS."

Thanks
Tao
>  
>  		ext4_set_inode_flags(inode);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

