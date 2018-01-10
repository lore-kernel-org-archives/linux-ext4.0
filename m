From: Sean Fu <fxinrong@gmail.com>
Subject: Re: [PATCH] ext4: Remove repeated test in ext4_file_read_iter.
Date: Wed, 10 Jan 2018 22:01:49 +0800
Message-ID: <20180110140149.GA5174@linux-zmni.DHCP>
References: <1514362798-5850-1-git-send-email-fxinrong@gmail.com>
 <20180103020805.GB21978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180103020805.GB21978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 03, 2018 at 02:08:05AM +0000, Al Viro wrote:
> On Wed, Dec 27, 2017 at 04:19:58PM +0800, Sean Fu wrote:
> > generic_file_read_iter has done the count test.
> > So ext4_file_read_iter don't need to test the count repeatedly.
> 
> Huh?  You do realize that generic_file_read_iter() is not the
> only variant possible there, right?
>
Yes, I know that generic_file_read_iter() is not the only variant possible.
The other possible dax_iomap_rw() with zero count would return zero.
> static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
> {
>         struct inode *inode = file_inode(iocb->ki_filp);
>         ssize_t ret;
> 
>         if (!inode_trylock_shared(inode)) {
>                 if (iocb->ki_flags & IOCB_NOWAIT)
>                         return -EAGAIN;
>                 inode_lock_shared(inode);
>         }
> 
> ... and now IOCB_NOWAIT read with zero count can fail with -EAGAIN.
>
Correct, IOCB_NOWAIT read with zero count can return -EAGAIN, But I
think that it is reasonable. while it got lock, zero would be returned
in this case.
