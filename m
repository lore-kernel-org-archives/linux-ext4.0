From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Date: Wed, 25 Nov 2015 11:25:00 +0100
Message-ID: <20151125102500.GM25232@quack.suse.cz>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
 <20151124132421.GG25232@quack.suse.cz>
 <20151124160723.GA17466@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151124160723.GA17466@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 24-11-15 08:07:23, Christoph Hellwig wrote:
> On Tue, Nov 24, 2015 at 02:24:21PM +0100, Jan Kara wrote:
> > Well, this problem seems to suggest that we have the freeze protection for
> > AIO writes wrong. We should call file_end_write() from aio_complete() and
> > not from aio_run_iocb()... I believe XFS and other filesystems may have
> > problems with this as well (CCed). Attached patch (so far only compile
> > tested since my test machine is pondering on something else) should fix
> > this.
> 
> Sounds like one way to do it, but we'd really want a vfs_* helper for
> this so that it doesn't have to duplicated in other write_iter users
> like the loop driver, which seems to be missing file
> file_start_write/file_end_write entirely.

That is mostly a separate issue, isn't it? I guess you mean a helper like
vfs_write_iter() that would get freeze protection and call ->write_iter()?
And what about files which have ->write (or ->splice_write()) and don't end
up calling ->write_iter? Also there is stuff like __kernel_write() which
ends up calling ->write_iter() but e.g. kernel/acct.c: do_acct_process()
wants to do it's own thing...

So the current status is not ideal but I don't see how to make it
substantially better...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
