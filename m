From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext4: Remove repeated test in ext4_file_read_iter.
Date: Wed, 3 Jan 2018 02:08:05 +0000
Message-ID: <20180103020805.GB21978@ZenIV.linux.org.uk>
References: <1514362798-5850-1-git-send-email-fxinrong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sean Fu <fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514362798-5850-1-git-send-email-fxinrong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 27, 2017 at 04:19:58PM +0800, Sean Fu wrote:
> generic_file_read_iter has done the count test.
> So ext4_file_read_iter don't need to test the count repeatedly.

Huh?  You do realize that generic_file_read_iter() is not the
only variant possible there, right?

static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
{
        struct inode *inode = file_inode(iocb->ki_filp);
        ssize_t ret;

        if (!inode_trylock_shared(inode)) {
                if (iocb->ki_flags & IOCB_NOWAIT)
                        return -EAGAIN;
                inode_lock_shared(inode);
        }

... and now IOCB_NOWAIT read with zero count can fail with -EAGAIN.
