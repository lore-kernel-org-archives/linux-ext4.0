From: Jan Kara <jack@suse.cz>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Thu, 12 Apr 2012 22:20:29 +0200
Message-ID: <20120412202029.GB19808@quack.suse.cz>
References: <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
 <20120412160658.GA9697@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jouni Siren <jouni.siren@iki.fi>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934754Ab2DLVhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Apr 2012 17:37:54 -0400
Content-Disposition: inline
In-Reply-To: <20120412160658.GA9697@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 13-04-12 00:06:59, Zheng Liu wrote:
> On Thu, Apr 12, 2012 at 05:47:41PM +0300, Jouni Siren wrote:
> > Hi,
> > 
> > I recently ran into problems when writing large blocks of data (more than about 2 GB) with a single call, if there is already some data in the write buffer. The problem seems to be specific to ext4, or at least it does not happen when writing to nfs on the same system. Also, the problem does not happen, if the write buffer is flushed before the large write.
> > 
> > The following C++ program should write a total of 4294967304 bytes, but I end up with a file of size 2147483664.
> > 
> > #include <fstream>
> > 
> > int
> > main(int argc, char** argv)
> > {
> >   std::streamsize data_size = (std::streamsize)1 << 31;
> >   char* data = new char[data_size];
> > 
> >   std::ofstream output("test.dat", std::ios_base::binary);
> >   output.write(data, 8);
> >   output.write(data, data_size);
> >   output.write(data, data_size);
> >   output.close();
> > 
> >   delete[] data;
> >   return 0;
> > }
> > 
> > 
> > The relevant part of strace is the following:
> > 
> > open("test.dat", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
> > writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}], 2) = -2147483640
> > writev(3, [{0xffffffff80c6d258, 2147483648}, {"", 2147483648}], 2) = -1 EFAULT (Bad address)
> > write(3, "\0\0\0\0\0\0\0\0", 8)         = 8
> > close(3)                                = 0
> > 
> > 
> > The first two writes are combined into a single writev call that reports having written -2147483640 bytes. This is the same as 8 + 2147483648, when interpreted as a signed 32-bit integer. After the first call, everything more or less fails. This happens on a Linux system, where uname -a returns
> > 
> > Linux alm01 2.6.32-220.7.1.el6.x86_64 #1 SMP Tue Mar 6 15:45:33 CST 2012 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > 
> > I believe that the bug can be found in file.c, function ext4_file_write, where variable ret has type int. Function generic_file_aio_write returns the number of bytes written as a ssize_t, and the returned value is stored in ret and eventually returned by ext4_file_write. If the number of bytes written is more than INT_MAX, the value returned by ext4_file_write will be incorrect.
> > 
> > If you need more information on the problem, I will be happy to provide it.
> 
> Hi Jouni,
> 
> Indeed, I think that it is a bug.  So the solution is straightforward.
> Could you please try this patch?  Thank you.
> 
> Regards,
> Zheng
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> Subject: [PATCH] ext4: change return value from int to ssize_t in ext4_file_write
> 
> in 32 bit platform, when we do a write operation with a huge number of data, it
> will cause that the ret variable overflows.  So it is replaced with ssize_t.
  Actually, the problem happens for 64-bit platforms. On 32-platforms,
ssize_t is 32-bit and thus we would do only a short write to fit into 2^31.
But on 64-bit, ssize_t is 64-bit so there we can end up writing more than
2^31. So please change the changelog. The patch itself is good, so you can
add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Reported-by: Jouni Siren <jouni.siren@iki.fi>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index cb70f18..8c7642a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -95,7 +95,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>  	int unaligned_aio = 0;
> -	int ret;
> +	ssize_t ret;
>  
>  	/*
>  	 * If we have encountered a bitmap-format file, the size limit
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
