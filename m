From: Josef Bacik <jbacik@fb.com>
Subject: Re: [RFC PATCH] coredump: avoid ext4 auto_da_alloc for core file
Date: Tue, 5 Jul 2016 09:42:13 -0400
Message-ID: <ae759802-f111-2c11-769e-e24e5dda4a5b@fb.com>
References: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<kernel-team@fb.com>
To: Omar Sandoval <osandov@osandov.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41609 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbcGENmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jul 2016 09:42:33 -0400
In-Reply-To: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/15/2016 01:42 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> Someone at Facebook reported that their coredumps were much faster when
> using a pipe helper than when dumping directly to a file, which doesn't
> make much sense. It turns out that this difference is because in
> do_coredump(), we truncate the core file and thus trigger the ext4
> auto_da_alloc heuristic. We can't use O_TRUNC because we might bail out
> of do_coredump() in certain conditions, so instead, avoid truncating
> when the file is already empty. In cases where we're actually
> overwriting a core file, this won't help, but the common case will be
> much better.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Hi, Al and Ted,
>
> This is probably the wrong solution to the problem I described in the
> commit message. Do you guys have any better ideas? Something like
> 0eab928221ba ("ext4: Don't treat a truncation of a zero-length file as
> replace-via-truncate") would also work, but that apparently wasn't
> right, as it was reverted in 5534fb5bb35a ("ext4: Fix the alloc on close
> after a truncate hueristic").
>
> Thanks.
>
>  fs/coredump.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 281b768000e6..9da7357773f0 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -741,8 +741,10 @@ void do_coredump(const siginfo_t *siginfo)
>  			goto close_fail;
>  		if (!(cprm.file->f_mode & FMODE_CAN_WRITE))
>  			goto close_fail;
> -		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
> -			goto close_fail;
> +		if (i_size_read(file_inode(cprm.file)) != 0) {
> +			if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
> +				goto close_fail;
> +		}
>  	}
>
>  	/* get us an unshared descriptor table; almost always a no-op */
>

Omar, this probably breaks the case where we do fallocate(FALLOC_FL_KEEP_SIZE), 
the i_size will be 0 but there will be blocks to truncate.  Probably want to 
check i_blocks or something.  Thanks,

Josef
