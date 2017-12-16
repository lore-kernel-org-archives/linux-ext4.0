From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: delayed inode update for the consistency of file
 size after a crash
Date: Sat, 16 Dec 2017 18:32:39 -0500
Message-ID: <20171216233239.oy4mcyjuq6hjugnx@thunk.org>
References: <20171216043326.GA12365@son-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Seongbae Son <seongbae.son@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171216043326.GA12365@son-VirtualBox>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 16, 2017 at 01:33:26PM +0900, Seongbae Son wrote:
> > > Details can be found as follows.
> > >
> > > Son et al. "Guaranteeing the Metadata Update Atomicity in EXT4 Filesystem”,
> > > In Proc. of APSYS 2017, Mumbai, India
> 
> > This is behind a paywall, so I can't access it.  I am sorry I wasn't
> > on the program committee, or I would have pointed this out while the
> > paper was being reviewed.
> 
> Thanks for your quick answer.
> I am sorry about that. I could not think about the paywall.

If you want to send me a PDF of the paper, I'm happy to look at it.

> I have performed the above scenario to xfs, btrfs, f2fs, and zfs.
> As the test result, all of the four file systems does not have the problem
> that fileA in which fsync() was not executed has the wrong file size
> after a system crash. So, I think, the portability of applications might be
> okay even though EXT4 guarantees the consistency between the file size and
> the data blocks of the file that fsync() is not executed after a system crash.

So first of all, there are more file systems than xfs, btrfs, f2fs,
and zfs, and there are more operating systems than Linux and Solaris.

Secondly, your patch doesn't solve the problem.  Updating the
timestamps without putting the changes in a transaction is no
guarantee; if some other process does some operation such as chmod,
et. al, the inode timestamps will get updated ahead of time.  Worse,
you are updating the i_size in a separate handle, right *before* the
write request is submitted.  So if a transaction commit gets started
immediately after call to ext4_journal_stop() which was added in
mpage_process_page_bufs(), it's still possible for i_size to be
updated and be visible after a crash, without the data block being
updated.  It's a narrower race window, but it's still there.

Furthermore, the patch is huge because the introduction of the new
functions _ext4_update_time(), ext4_update_time(),
_generic_file_write_iter() have included a large amount of extra lines
of code which are copied from elsewhere --- e.g., this is "reverse
code factoring" --- and it makes the resulting source less
maintainable.  And the fact that it forces every single write which
affects the last block in the file to be written *twice* means that it
has really unfortunate real performance impacts for workloads which
are appending to a file (e.g., any kind of log file).

If you really want to solve this problem, what needs to be done is
that update of the timestamp and i_size needs to be moved to an I/O
completion handler.  We do this already to convert unwritten requests
to be written in fs/ext4/page_io.c.  See ext4_put_io_end_defer() in
fs/ext4/page_io.c; if we need to convert unwritten extents the
EXT4_IO_END_UNWRITTEN flag is set, and ext4_add_complete_io() tacks
the io_end queue onto a workqueue.  This infrastructure could be made
more general so that it can do other work after the I/O has been
completed, including the i_size update.

I'm not really convinced it's worth it, but this would be a much more
efficient way of solving the problem, and it would avoid need to clone
a large amount of code both in ext4 and in the generic mm/filemap.c
file.

Best regards,

					- Ted
