From: Sean Fu <fxinrong@gmail.com>
Subject: Re: [PATCH] ext4: Remove repeated test in ext4_file_read_iter.
Date: Tue, 16 Jan 2018 16:10:33 +0800
Message-ID: <20180116081033.GA3436@linux-zmni.apac.novell.com>
References: <1514362798-5850-1-git-send-email-fxinrong@gmail.com>
 <20180103020805.GB21978@ZenIV.linux.org.uk>
 <20180110140149.GA5174@linux-zmni.DHCP>
 <20180110200255.GA6499@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110200255.GA6499@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 10, 2018 at 03:02:55PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 10, 2018 at 10:01:49PM +0800, Sean Fu wrote:
> >
> > Correct, IOCB_NOWAIT read with zero count can return -EAGAIN, But I
> > think that it is reasonable. while it got lock, zero would be returned
> > in this case.
> 
> Returning -EAGAIN and 0 are not the same thing.  Specifically
> returning 0 means "end of file".  Hence, it is NOT reasonable.
> 
I know that two returnning value mean different things.
once the inode is not under lock contention, read again with zero count
would return zero.
> See the man page for read(2) or the relevant Single Unix Specification
> standard:
> 
> RETURN VALUE
>      On success, the number of bytes read is returned (zero indicates
>      end of file)....
> 
> Changing the behavior of the system in which will break userspace is
> never acceptable, and even more so given that this is just a "cleanup
> patch".
>
I agree with you at this point.
Thanks for your reply.

> 						- Ted
> 
