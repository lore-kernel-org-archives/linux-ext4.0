From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: do not print any error message from libext2fs
Date: Mon, 20 May 2013 22:36:36 -0400
Message-ID: <20130521023636.GA586@thunk.org>
References: <1367059481-6090-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50117 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab3EUCgm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 22:36:42 -0400
Content-Disposition: inline
In-Reply-To: <1367059481-6090-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 27, 2013 at 06:44:41PM +0800, Zheng Liu wrote:
> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index ca39b4b..e042fd7 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -388,8 +388,11 @@ void do_dirsearch(int argc, char *argv[])
>  	pb.len = strlen(pb.search_name);
>  
>  	if (ext2fs_inode_has_inline_data(current_fs, inode)) {
> -		ext2fs_inline_data_dirsearch(current_fs, inode,
> +		errcode_t retval;
> +		retval = ext2fs_inline_data_dirsearch(current_fs, inode,
>  					     argv[2], strlen(argv[2]));
> +		if (retval)
> +			printf("Entry found at inline data\n");
>  		goto out;
>  	}

The problem with this is that ext2_inline_data_dirsearch() also
returns a non-zero error code.  So it returns 0 if the entry is not
found in the inline data, 1 if it is found in the inline data, and
some other error code --- and if some system call returns EPERM (which
is one) there will be a collision.

This is an example of a badly designed library interface; and since I
don't want to break backwards compatibility by removing a library
interface once we've added one, we need to be very careful for each
new interface that we are thinking of adding.

In this particular case, it's not clear to me that this library
interface is at all useful, or that dirsearch needs to support inline
directories at all in the first place.  The only reason dirsearch
exists is to debug very large htree directories where the index has
gotten corrupted.  For a small inline directory, it's just as easy to
check to see what's in the directory by using the "ls" command.

So having dirsearch simply give an error and not support inline data
directory, or to have dirsearch work by iterating over each of the
entries in the inline data directory would both be acceptable
alternatives.

And we need to carry out a similar very careful examination of all of
the other new interfaces added to inline_data.c.  Sometimes it helps
to document exactly what it is that this interface is doing, and what
does it return under what circumstance.  Then think about what the
best generic interface would be for all possible future users of that
interface, not just the one or ones in the current e2fsprogs tree.
And if there is only one caller of a particular interface, then it may
be fair to ask the question whether it should be in the library at
all.

Regards,

						- Ted
