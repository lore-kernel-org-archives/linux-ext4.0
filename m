From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] coredump: avoid ext4 auto_da_alloc for core file
Date: Mon, 4 Jul 2016 11:11:37 -0400
Message-ID: <20160704151137.GE29557@thunk.org>
References: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
 <20160629183444.GA3030@vader>
 <20160704022455.GA28883@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, kernel-team@fb.com
To: Omar Sandoval <osandov@osandov.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160704022455.GA28883@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 03, 2016 at 10:24:55PM -0400, Theodore Ts'o wrote:
> From bf21c027d84ded545d2c08fa01fd184d29641458 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sun, 3 Jul 2016 22:20:49 -0400
> Subject: [PATCH] ext4: in ext4_setattr(), only call ext4_truncate() if there is no data to drop
> 
> If there are no blocks associated with the inode (and no inline data),
> there's no point calling ext4_truncate().  This avoids setting the
> replace-via-truncate hueristic if there is an attempt to truncate a
> file which is already zero-length --- which is something that happens
> in the core dumping code, in case there is an already existing core
> file.  In the comon case, there is not a previous core file, so by not
> enabling the replace-via-truncate hueristic, we can speed up core
> dumps.
> 
> Reported-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

This patch is buggy; when I tried running regression tests, it failed
early.  So you probably want to skip this.

					- Ted
					
