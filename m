From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V7 00/23] ext4: Add inline data support
Date: Mon, 10 Dec 2012 23:17:24 +0800
Message-ID: <50C5FD04.9070206@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma> <20121206173022.GE30273@thunk.org> <50C147A0.4070109@tao.ma> <20121210150228.GA28666@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:50104 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752562Ab2LJPRk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2012 10:17:40 -0500
In-Reply-To: <20121210150228.GA28666@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/10/2012 11:02 PM, Theodore Ts'o wrote:
> On Fri, Dec 07, 2012 at 09:34:24AM +0800, Tao Ma wrote:
>> I think ext4_inode->xattr_sem should protect us? When we do xattr
>> corresponding operation, we just do
>> down_write/read(&EXT4_I(inode)->xattr_sem), so we should be fine with
>> this type of operation. Am I missing something here?
> 
> We're not taking the xattr_sem in ext4_find_inline_data() before we
> call ext4_xattr_ibody_find().  So I think we need something like this:
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 6b600b4..e96268d 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -143,7 +143,9 @@ int ext4_find_inline_data(struct inode *inode)
>  	if (error)
>  		return error;
>  
> +	down_read(&EXT4_I(inode)->xattr_sem);
>  	error = ext4_xattr_ibody_find(inode, &i, &is);
> +	up_read(&EXT4_I(inode)->xattr_sem);
>  	if (error)
>  		goto out;
Actually ext4_find_inline_data is only called in ext4_iget when we
initialize an inode from the disk and that's the reason why I didn't add
this lock. So maybe the name isn't obvious to the reader.  :(

Having said that, I think it should be safe for us to add this lock so
that any future user may abuse it without any worry about the xattr
lock. So go ahead with it.

Thanks
Tao
