From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2 1/1] ext4: don't put symlink in pagecache into highmem
Date: Tue, 6 Feb 2018 12:39:53 -0800
Message-ID: <20180206203953.GC18045@kroah.com>
References: <20180206190938.172792-1-jinqian@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jin Qian <jinqian@android.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jin Qian <jinqian@google.com>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbeBFUjy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Feb 2018 15:39:54 -0500
Content-Disposition: inline
In-Reply-To: <20180206190938.172792-1-jinqian@android.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 06, 2018 at 11:09:37AM -0800, Jin Qian wrote:
> From: Jin Qian <jinqian@google.com>
> 
> partial backport from 21fc61c73c3903c4c312d0802da01ec2b323d174 upstream
> to v4.4 to prevent virt_to_page on highmem.
> 
> ext4_encrypted_follow_link uses kmap() for cpage
>   caddr = kmap(cpage);
> 
> _ext4_fname_disk_to_usr calls virt_to_page on the kmapped address.
>   _ext4_fname_disk_to_usr()
>     ext4_fname_decrypt()
>       sg_init_one()
>         sg_init_one(&src_sg, iname->name, iname->len);
>           sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Jin Qian <jinqian@google.com>
> Signed-off-by: Jin Qian <jinqian@android.com>

Ted, any objection to this patch?

thanks,

greg k-h
