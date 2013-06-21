From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 16:35:47 -0400
Message-ID: <20130621203547.GA10582@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ryan Lortie <desrt@desrt.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60153 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945951Ab3FUUfv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 16:35:51 -0400
Content-Disposition: inline
In-Reply-To: <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I've been taking a closer look at the the rename code, and there's
something I can do which will improve the chances of avoiding data
loss on a crash after an application tries to replace file contents
via:

1)  write foo.new
2)  <omit fsync of foo.new>
3)  rename foo.new to foo

Those are the kernel patches that I cc'ed you on.

The reason why it's still not a guarantee is because we are not doing
a file integrity writeback; this is not as important for small files,
but if foo.new is several megabytes, not all of the data blocks will
be flushed out before the rename, and this will kill performance, and
in somoe cases it might not be necessary.

Still, for small files ("most config files are smaller than 100k"),
this should serve you just fine.  Of course, it's not going to be in
currently deployed kernels, so I don't know how much these proposed
patches will help you,.  I'm doing mainly because it helps protects
users against (in my mind) unwise application programmers, and it
doesn't cost us any extra performance from what we are currently
doing, so why not improve things a little?


If you want better guarantees than that, this is the best you can do:

1)  write foo.new using file descriptor fd
2)  sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WRITE);
3)  rename foo.new to foo

This will work on today's kernels, and it should be safe to do for all
file systems.  What sync_file_range() will do is to force out all of
the data blocks (and if foo.new is a some gaurgantuan DVD ISO image,
you may stall for seconds or minutes while the data blocks are written
back).  It does not force out any of the metadata blocks, or issue a
CACHE_FLUSH command.  But that's OK, because after the rename()
operation, at the next journal commit the metdata blocks will be
flushed out, and the journal commit will issue a CACHE FLUSH command
to the disk.

So this is just as safe as using fsync(), and it will be more
performant.  However, sync_file_range(2) is a Linux-specific system
call, so if you care about portability to other operating systems,
you'll have to use fsync() instead on legacy Unix systems.  :-)


On Fri, Jun 21, 2013 at 11:24:45AM -0400, Ryan Lortie wrote:
> 
> So why are we seeing the problem happen so often?  Do you really think
> this is related to a bug that was introduced in the block layer in 3.0
> and that once that bug is fixed replace-by-rename without fsync() will
> become "relatively" safe again?

So there are a couple of explanations I can think of.  As I said, at
least one of the test programs was not actually doing a rename()
operation to overwrite an existing file.  So in that case, seeing a
zero-length file after a crash really isn't unexpected.  The btrfs
wiki also makes it clear that if you aren't doing a rename which
deletes an old file, there are no guarantees.

For situations where the application really was doing rename() to
overwrite an existing file, we were indeed initiating a
non-data-integrity writeback after the rename.  So most of the time,
users should have been OK.  Now, if the application is still issuing
lots and lots of updates, say multiple times a second while a window
is being moved around, or even once for every single window
resize/move, it could just have been a case of bad luck.

Another example of bad luck might be the case of Tux Racer writing its
high score file, and then shutting down its Open GL context, which
promptly caused the Nvidia driver to crash the entire system.  In that
case, the two events would be highly correlated together, so the
chances that the user would get screwed would thus be much, much
higher.

Yet another possible cause is crappy flash devices.  Not all flash
devices are forcing out their internal flash translation layer (FTL)
metadata to stable store on a CACHE FLUSH command --- precisely
because if they did, it would trash their performance, and getting
good scores on AnandTech rankings might be more important to them than
the safety of their user's data.

As a result, even for an application which is properly calling
fsync(), you could see data loss or even file system corruption after
a power failure.  I recently helped out an embedded systems engineer
who was trying to use ext4 in an appliance, and he was complaining
that with this Intel SSD things worked fine, but with his Brand X SSD
(name ommited to protect the guilty) he was seeing file system
corruption after a power plug pull test.  I had to tell them that
there was nothing I could do.  If the storage device isn't flushing
everything to stable store upon receipt of a CACHE FLUSH command, that
would be like a file system which didn't properly implement fsync().
If the application doesn't call fsync(), then it's on the application.
But if the application calls fsync(), and data loss still occurs, then
it's on either the file system or the storage device.

Similarly, if the file system doesn't send a CACHE FLUSH command, it's
on the file system (or the administrator, if he or she uses the
nobarrier mount option, which disables the CACHE FLUSH command).  But
if the file system does send the CACHE FLUSH command, and the device
isn't guaranteeing that all data sent to the storage device can be
read after a power pull, then it's on the storage device, and it's the
storage device which is buggy.

> g_file_set_contents() is a very general purpose API used by dconf but
> also many other things.  It is being used to write all kinds of files,
> large and small.  I understand how delayed allocation on ext4 is
> essentially giving me the same thing automatically for small files that
> manage to be written out before the kernel decides to do the allocation
> but doing this explicitly will mean that I'm always giving the kernel
> the information it needs, up front, to avoid fragmentation to the
> greatest extent possible.  I see it as "won't hurt and may help" and
> therefore I do it.

So that would be the problem if we defined some new interface which
implemented a replace data contents functionality.  Inevitably it
would get used by some crazy application which tried to write a
multi-gigabyte file....

If I were to define such a new syscall, what I'd probably do is export
it a set_contents() type interface.  So you would *not* use read or
write, but you would send down a the new contents in a single data
buffer, and if it is too big (where too big is completely at the
discretion of the kernel) you would get back an error, and it would be
up to the application to fall back to the traditional methods of
"write to foo.new, rename foo.new to foo" scheme.

I don't know if I could get the rest of the file system developers to
agree to such an interface, but if we were to do such a thing, that's
the proposal I would make.  On the other hand, you keep telling me
that dconf() is only intended to be used for small config files, and
applications should only be calling it but rarely.

In that case, does it really matter if g_file_set_contents() takes a
tenth of a second or so?  I can see needing to optimize things if
g_file_set_contents() is getting called several times a second as the
window is getting moved or resized, but I thought we've agreed that's
an abusive use of the interface, and hence not one we should be trying
to spend huge amounts of programming effort trying to optimize.

> > The POSIX API is pretty clear: if you care about data being on disk,
> > you have to use fsync().
> 
> Well, in fairness, it's not even clear on this point.  POSIX doesn't
> really talk about any sort of guarantees across system crashes at all...

Actually, POSIX does have clear words about this:

    "If _POSIX_SYNCHRONIZED_IO is defined, the fsync() function shall
    force all currently queued I/O operations associated with the file
    indicated by file descriptor fildes to the synchronized I/O
    completion state. All I/O operations shall be completed as defined
    for synchronized I/O file integrity completion"

And yes, Linux is intended to be implemented with the
_POSIX_SYNCHRONIZED_IO defined.  There are operating systems where
this might not be true, though.  For example, Mac OS X.

Fun Trivia fact; on Mac OS, fsync doesn't result in a CACHE FLUSH
command, so the contents of your data writes are not guaranteed after
a power failure.  If you really want fsync(2) to perform as specified
by POSIX, you must use fcntl and F_FULLFSYNC on Mac OS.  The reason?
Surprise, surprise --- performance.  And probably because there are
too many applications which were calling fsync() several times a
second during a window resize on the display thread, or some such, and
Steve Jobs wanted things to be silky smooth.  :-)

Another fun fact: firefox used to call fsync() on its UI thread.
Guess who got blamed for the resulting UI Jank and got all of the hate
mail from the users?  Hint: not the Firefox developers.... and this
sort of thing probably explains Mac OS's design decision vis-a-vis
fsync().  There are a lot of application programmers out there, and
they outnumber the file system developers --- and not all of them are
competent.

> and I can easily imagine that fsync() still doesn't get me what I want
> in some really bizarre cases (like an ecryptfs over NFS from a virtual
> server using an lvm setup running inside of kvm on a machine with hard
> dives that have buggy firmware).

Yes, there are file systems such as NFS which are not POSIX compliant.
And yes, you can always have buggy hardware, such as the crap SSD's
that are out there.  But there's nothing anyone can do if the hardware
is crap.  

(There's a reason why I tend to stick to Intel SSD's on my personal
laptops.  More recently I've experimented with using a Samsung SSD on
one of my machines, but in general, I don't use SSD's from random
manufacturers precisely because I don't trust them.....)

> 
> This is part of why I'd rather avoid the fsync entirely...

Well, for your use case, sync_file_range() should actually be
sufficient, and it's what I would recommend instead of fsync(), at
least for Linux which has this syscall.

> aside: what's your opinion on fdatasync()?  Seems like it wouldn't be
> good enough for my usecase because I'm changing the size of the file....

fdatasync() is basically sync_file_range() plus a CACHE FLUSH command.
Like sync_file_range, it doesn't sync the metadata (and by the way,
this includes things like indirect blocks for ext2/3 or extent tree
blocks for ext4).

However, for the "write foo.new ; rename foo.new to foo" use case,
either sync_file_range() or fdatasync() is fine, since at the point
where the rename() is committed via the file system transaction, all
of the metadata will be forced out to disk, and there will also be a
CACHE FLUSH sent to the device.  So if the desired guarantee is "file
foo contains either the old or new data", fsync(), fdatasync() or
sync_file_range() will all do, but the sync_file_range() will be the
best from a performance POV, since it eliminates a duplicate and
expensive CACHE FLUSH command from being sent to the disk.

> another aside: why do you make global guarantees about metadata changes
> being well-ordered?  It seems quite likely that what's going on on one
> part of the disk by one user is totally unrelated to what's going on on
> another other part by a different user... ((and I do appreciate the
> irony that I am committing by complaining about "other guarantees that I
> don't care about")).

There are two answers.  One is that very often there are dependencies
between files --- and at the file system level, we don't necessarily
know what these dependencies are (for example, between a .y and .c
file, and a .c and a .o files with respect to make).  There may be
(many) files for which it doesn't matter, but how do you tell the file
system which file dependencies matters and which doesn't?

There's another reason why, which is that trying to do this would be
horrifically complicated and/or much, much slower.  The problem is
entangled updates.  If you modify an inode, you have to write back the
entire inode table block.  There may be other inodes that are also in
the procss of being modified.  Similarly, you might have a rename
operation, an unlink operation, and a file write operation that all
result in changes to a block allocation bitmap.  If you want to keep
these operations separate, then you need to have a very complicated
transaction machinery, with intent logs, and rollback logs, and all of
the rest of the massive complexity that comes with a full-fledged
transactional database.  There have been attempts to use a general
database engine to implement a generic file system, but they have
generally been a performance disaster.  One such example happened in
the early 90's, when Oracle tried push this concept in order to sell
more OracleDB licenses, but that went over like a lead balloon, and
not just because of the pricing issue.

						- Ted
