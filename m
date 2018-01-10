From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove repeated test in ext4_file_read_iter.
Date: Wed, 10 Jan 2018 15:02:55 -0500
Message-ID: <20180110200255.GA6499@thunk.org>
References: <1514362798-5850-1-git-send-email-fxinrong@gmail.com>
 <20180103020805.GB21978@ZenIV.linux.org.uk>
 <20180110140149.GA5174@linux-zmni.DHCP>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sean Fu <fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110140149.GA5174@linux-zmni.DHCP>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 10, 2018 at 10:01:49PM +0800, Sean Fu wrote:
>
> Correct, IOCB_NOWAIT read with zero count can return -EAGAIN, But I
> think that it is reasonable. while it got lock, zero would be returned
> in this case.

Returning -EAGAIN and 0 are not the same thing.  Specifically
returning 0 means "end of file".  Hence, it is NOT reasonable.

See the man page for read(2) or the relevant Single Unix Specification
standard:

RETURN VALUE
     On success, the number of bytes read is returned (zero indicates
     end of file)....

Changing the behavior of the system in which will break userspace is
never acceptable, and even more so given that this is just a "cleanup
patch".

						- Ted
