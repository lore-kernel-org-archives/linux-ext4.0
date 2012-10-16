From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] Use 'inode' variable that is already dereferenced
Date: Tue, 16 Oct 2012 10:28:03 +0800
Message-ID: <20121016022803.GA5155@gmail.com>
References: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:61561 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2JPCRC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2012 22:17:02 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so2901935dak.19
        for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 19:17:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 12:06:48PM -0700, Anatol Pomozov wrote:
> Tested: xfs tests
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
> ---
>  fs/ext4/page-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 68e896e..0fd16e6 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -111,7 +111,7 @@ static int ext4_end_io(ext4_io_end_t *io)
>  		inode_dio_done(inode);
>  	/* Wake up anyone waiting on unwritten extent conversion */
>  	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> -		wake_up_all(ext4_ioend_wq(io->inode));
> +		wake_up_all(ext4_ioend_wq(inode));

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
