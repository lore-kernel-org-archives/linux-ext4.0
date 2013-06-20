From: Ryan Lortie <desrt@desrt.ca>
Subject: ext4 file replace guarantees
Date: Thu, 20 Jun 2013 17:34:18 -0400
Message-ID: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60499 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758033Ab3FTVmq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 17:42:46 -0400
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway2.nyi.mail.srv.osa (Postfix) with ESMTP id 4EAC1203EF
	for <linux-ext4@vger.kernel.org>; Thu, 20 Jun 2013 17:34:18 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

I recently read the kernel documentation on the topic of guarantees
provided by ext4 when renaming-over-existing.  I found this:

(*) == default

auto_da_alloc(*)        Many broken applications don't use fsync() when 
noauto_da_alloc             replacing existing files via patterns such
as
                   			fd =
                   			open("foo.new")/write(fd,..)/close(fd)/
                   			rename("foo.new", "foo"), or
                   			worse yet,
                   			fd = open("foo",
                   			O_TRUNC)/write(fd,..)/close(fd).
                   			If auto_da_alloc is enabled,
                   			ext4 will detect
                   			the replace-via-rename and
                   			replace-via-truncate
                   			patterns and force that any
                   			delayed allocation
                   			blocks are allocated such that
                   			at the next
                   			journal commit, in the default
                   			data=ordered
                   			mode, the data blocks of the new
                   			file are forced
                   			to disk before the rename()
                   			operation is
                   			committed.  This provides
                   			roughly the same level
                   			of guarantees as ext3, and
                   			avoids the
                   			"zero-length" problem that can
                   			happen when a
                   			system crashes before the
                   			delayed allocation
                   			blocks are forced to disk.


in https://www.kernel.org/doc/Documentation/filesystems/ext4.txt

which says to me "replace by rename is guaranteed safe in modern ext4,
under default mount options".

I understand that this was added after the "ext4 is eating my data"
panic in 2009.

Knowing that ext4 provides this guarantee caused me to modify GLib to
remove the fsync() that we used to do from g_file_set_contents(), if we
detect that we are on ext2/3/4:

  https://git.gnome.org/browse/glib/commit/?id=9d0c17b50102267a5029b58b1f44efbad82d8f03

(we already skipped the fsync() on btrfs since this filesystem
guarantees that replace-by-rename is safe):

"""
What are the crash guarantees of overwrite-by-rename?

Overwriting an existing file using a rename is atomic. That means that
either the old content of the file is there or the new content. A
sequence like this: 
"""

in
https://btrfs.wiki.kernel.org/index.php/FAQ#What_are_the_crash_guarantees_of_overwrite-by-rename.3F

We don't really care too much about ext2 (although it would be great if
there was a convenient API to detect the difference between
ext2/ext3/ext4 filesystems since they all share one magic number).

Anyway... by mistake, this patch (removing fsync on ext4) got backported
into one of our stable releases and landed in Debian and the Fedora 19
beta, where many users started reporting data loss.

So what's the story here?  Is this safe or not?


The _only_ thing that I can think of is that GLib also does an
fallocate() before writing the data.  Does doing fallocate() before
write() void the rename-is-safe guarantees or is this just a filesystem
bug?

In any case, we have reverted the patch for now to work around the
issue.

It would be great if I could find out some official word on what the
guaranteed behaviour of the filesystem is with respect to
replace-by-rename.  Trying to dance around these issues is starting to
get a bit annoying...

Thanks in advance.
