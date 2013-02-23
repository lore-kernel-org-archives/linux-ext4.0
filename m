From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] f_pos in readdir() (was Re: [RFC][PATCH] vfs: always protect
 diretory file->fpos with inode mutex)
Date: Sat, 23 Feb 2013 17:35:21 +0000
Message-ID: <20130223173521.GP4503@ZenIV.linux.org.uk>
References: <5122D3E0.6070800@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
	Wuqixuan <wuqixuan@huawei.com>, gregkh@linuxfoundation.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5122D3E0.6070800@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 19, 2013 at 09:22:40AM +0800, Li Zefan wrote:
> There's a long long-standing bug...As long as I don't know when it dates
> from.
> 
> I've written and attached a simple program to reproduce this bug, and it can
> immediately trigger the bug in my box. It uses two threads, one keeps calling
> read(), and the other calling readdir(), both on the same directory fd.

> While readdir() is protected with i_mutex, f_pos can be changed without any locking
> in various read()/write() syscalls, which leads to this bug.

_What_ read/write syscalls (on a directory, that is)?

> We can fix this bug in each filesystem, but can't we just make sure i_mutex is
> acquired in lseek(), read(), write() and readdir() for directory file operations?
> 
> (the patch is for demonstration only)

No.  This is a very massive overkill.  If anything, we want to *reduce* the
amount of time we hold ->i_mutex in that area.

There are several bugs mixed here:
	* disappearing exclusion between readdir and lseek for directories.
Bad, since offset validation suddenly needs to be redone every time we look
at ->f_pos in ->readdir() instances *and* since ->readdir() itself updates
position, often by file->f_pos += something.
	* write(2) doing "get a copy of f_pos, try and fail ->write(),
put that copy back".  With no locking whatsoever.  What we get is a f_pos
value reverting to what it used to be at some random earlier point.  Makes
life really nasty for everything that updates ->f_pos, obviously.
	* read(2) doing the same, *and* some directories apparently having
->read() now.

->readdir() part of that would be the simplest one - we need to stop messing
with ->f_pos and just pass an address of its copy, like we do for ->read()
et.al.  Preserving the method prototype is not worth it and this particular
method has needed an overhaul of calling conventions for many reasons.

The issue with write(2) and friends is potentially nastier.  I'm looking
at the ->f_pos users right now, and while the majority are ->readdir()
and ->llseek() instances, there's some stuff beyond that.  Some of that is
done with struct file opened kernel-side and not accessible to userland;
those are safe (and often really ugly - see drivers/media/pci/cx25821/
hits for f_pos).  Some are simply wrong - e.g. dev_mem_read()
(in drivers/net/wireless/ti/wlcore/debugfs.c) ignores *ppos value and uses
file->f_pos instead; wrong behaviour for ->read() instance.  I'm about
20% through the list; so far everything seems to be possible to deal with
(especially if we add a couple of helpers for common lseek variants and
use existing generic_file_llseek_size()), so it might turn out to be
not a serious issue, but it's a potential minefield.  Hell knows...

As for ->readdir(), I'd like to resurrect an old proposal to change the ABI
of that sucker.  Quoting the thread from 4 years ago:
====
As for the locking...  I toyed with one idea for a while: instead of passing
a callback and one of many completely different structs, how about a common
*beginning* of a struct, with callback stored in it along with several
common fields?  Namely,
        * count of filldir calls already made
        * pointer to file in question
        * "are we done" flag
And instead of calling filldir(buf, ...) ->readdir() would call one of several
helpers:
        * readdir_emit(buf, ...) - obvious
        * readdir_relax(buf) - called in a spot convenient for dropping
and retaking lock; returns whether we need to do revalidation.
        * readdir_eof(buf) - end of directory
        * maybe readdir_dot() and readdir_dotdot() - those are certainly
common enough
That's the obvious flagday stuff, but since we need to give serious beating
to most of the instances anyway...  Might as well consider something in
that direction.
====

Back then it didn't go anywhere, but if we really go for change of calling
conventions (passing a pointer to copy of ->f_pos), it would make a lot of
sense, IMO.  Note that ->i_mutex contention could be seriously relieved that
way - e.g. ext* would just call readdir_relax() at the block boundaries,
since those locations are always valid there, etc.

Comments?
