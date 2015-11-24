From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Date: Tue, 24 Nov 2015 08:07:23 -0800
Message-ID: <20151124160723.GA17466@infradead.org>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
 <20151124132421.GG25232@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151124132421.GG25232@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 24, 2015 at 02:24:21PM +0100, Jan Kara wrote:
> Well, this problem seems to suggest that we have the freeze protection for
> AIO writes wrong. We should call file_end_write() from aio_complete() and
> not from aio_run_iocb()... I believe XFS and other filesystems may have
> problems with this as well (CCed). Attached patch (so far only compile
> tested since my test machine is pondering on something else) should fix
> this.

Sounds like one way to do it, but we'd really want a vfs_* helper for
this so that it doesn't have to duplicated in other write_iter users
like the loop driver, which seems to be missing file
file_start_write/file_end_write entirely.
