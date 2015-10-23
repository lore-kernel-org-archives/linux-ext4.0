From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question about ext4 journal
Date: Fri, 23 Oct 2015 08:50:33 -0400
Message-ID: <20151023125033.GD7917@thunk.org>
References: <CALLJCT3fAapW4aCSNPekeB8wx6XOU4O_PKfvQ7VhY-t8hrPBnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40171 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbbJWMvQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Oct 2015 08:51:16 -0400
Content-Disposition: inline
In-Reply-To: <CALLJCT3fAapW4aCSNPekeB8wx6XOU4O_PKfvQ7VhY-t8hrPBnA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 23, 2015 at 01:04:54PM +0900, Masanari Iida wrote:
> Hello Developer,
> I have a question about ext4's internal.
> 
> OS: RHEL6.2
> Filesystem EXT4
> mount option = ordered
> 
> My understanding on ext4 with ordered mode,
> When a file is created,  data is written to FS block,
> At the same time,  metadata is stored into journal,
> and then meta data on journal is written to the inode block.
> What is the next?

Well, that's not quite a complete picture.  Ext4 has an advanced
feature called delayed allocation, which means that the FS block is
not allocated until writeback occurs.

So there is some file system metadata which is modified as soon as the
file is created (i.e., the directory, inode allocation bitmap, the
inode table block itself), and this is held in memory until the
journal commit is triggered (either every five seconds, or if the size
of the transaction grows beyond a certian size, or an fsync), at which
point the metadata blocks that have been modified since the last
commit are written into the journal, and once the commit block is
written, the modified metadata blocks are _allowed_ to be written back
to disk by the normal writeback mechanisms.

When the data writeback timer expires (30 seconds by default), then
writeback happens.  It's only then that the location on disk is
determined, and when the block is allocated, this will result in more
metadata blocks getting modified, which are handled as described
above.  In general once we've allocated the block, the write to disk
is immediately scheduled, and the commit that commits the will happen
shortly after.

> My question is
> Does the kernel remove the meta data on journal after each successful
>  transaction?

The journal is a circular buffer.  Once all of the blocks that
participated in the a jbd2 transaction have been written back to their
final location on disk, the transaction gets retired.  However, we
don't necessarily automatically update the jbd2 superblock's tail
pointer each time a transaction can be retired, because doing this to
"remove" one or more transsaction requires a write to the jbd2
superblock, and we want to minimize unnecessary writes.  This might
mean that when we recover after a crash, we might end up replaying
some transcations that don't need to be replayed, but that should be
an uncommon case that we shouldn't be optimizing for.

> As I see the contents of journal entries in EXT4 using debugfs(8),
> the journal entries are growing when creating or deleting the files.
> I am curious to know what make the system to remove journal entries
> while mounted the fs.
> 
> Background of the question.
> I have encountered a case that when I delete and create some files,
> journal entry for deleting the file exist
> But journal entry for creating the file was not exist.
> FYI, the file itself exist when I see it by using debugfs.
> 
> I created snapshot of the filesystem and  run fsck on copy image.
> Then the file was _removed_ by fsck operation.
> This is why I want to know how journal on EXT4 were controlled.

This is too vague for me to comment.  If you give very detailed of
what file system operations you might have been trying to do, and
whether you called fsync(2) or not, and how long you waited before
taking the snapshot, that would be helpful.

I will observe that because of delayed allocation, if you don't wait
for the writeback timer to expire, if you take a snapshot or there is
a crash immediately after writing the file, what you might find after
the recovery process is a zero-length file.  If you want to make sure
a file and its contents will be there after a crash, make sure you call
the fsync() system call.

						- Ted
						
