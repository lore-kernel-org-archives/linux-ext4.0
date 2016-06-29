From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH] coredump: avoid ext4 auto_da_alloc for core file
Date: Wed, 29 Jun 2016 11:34:44 -0700
Message-ID: <20160629183444.GA3030@vader>
References: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kernel-team@fb.com
To: Al Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 15, 2016 at 10:42:05AM -0700, Omar Sandoval wrote:
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

Ping, any thoughts on this?

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
> -- 
> 2.8.3
> 

-- 
Omar
