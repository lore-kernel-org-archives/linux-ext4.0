From: "Theodore Ts'o" <tytso@mit.edu>
Subject: RFC: Clarifying Direct I/O Semantics
Date: Fri, 21 Aug 2009 17:54:48 -0400
Message-ID: <E1Mec4O-0005ka-NN@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54589 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbZHUVyu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2009 17:54:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


As we had discussed on a previous ext4 conference call, I've created a
formal write up of Direct I/O's semantics as they currently exist in
Linux.  As far as I know it accurately reflects what we are currently
doing today, so this is really more of a "document what we are doing"
than any thing else.

Before I send this out to for wider review. could folks here take a look
at it and let me know if I've made any embarassing mistakes or
mis-statements?

http://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics

Thanks!!

						- Ted

P.S.  For people who are too lazy to click on the above link, here's the
version of the page as of this writing :-)

= Introduction = 

The exact semantics of Direct I/O (O_DIRECT) are well specified. It is
not a part of POSIX, or SUS, or any other formal standards
specification. The exact meaning of O_DIRECT has historically been
negotiated in non-public discussions between powerful enterprise
database companies and proprietary Unix systems, and its behaviour has
generally been passed down as oral lore rather than as a formal set of
requirements and specifications.

The goal of this page is to summarize the current status, and to propose
a more fully-fleshed out set of semantics for O_DIRECT which Linux file
filesystem developers can agree, and for which application programmers
(especially open source database implementors who may not have had an
opportunity to have the same set of discussions with OS implementors as
the large enterprise database developers have had). Once there is
consensus, this wiki page should also be used as the basis for updating
the Linux kernel man page for open(2).

= Ambiguities =

The Linux kernel man page for open(2) states:

    Try to minimize cache effects of the I/O to and from this file. In
    general this will degrade performance, but it is useful in special
    situations, such as when applications do their own caching. File I/O
    is done directly to/from user space buffers. The I/O is synchronous,
    that is, at the completion of a read(2) or write(2), data is
    guaranteed to have been transferred. See NOTES below for further
    discussion....

    The O_DIRECT flag may impose alignment restrictions on the length
    and address of userspace buffers and the file offset of I/Os. In
    Linux alignment restrictions vary by file system and kernel version
    and might be absent entirely. However there is currently no file
    system-independent interface for an application to discover these
    restrictions for a given file or file system. Some file systems
    provide their own interfaces for doing so, for example the
    XFS_IOC_DIOINFO operation in xfsctl(3).

==  Fallback behavior ==

The Linux man page does not state what happens if the alignment
restrictions are not met; does the kernel start running rogue or
nethack; does it send a signal such as SIGSEGV or SIGABORT, and kill the
running process; or does it fall back to buffered I/O? Today, the answer
is the latter; but it's not specified anywhere.

This is relatively well understood by most implementors and users of
O_DIRECT as part of the "oral lore", so simply updating the Linux man
page should not be controversial.

== Extending writes ==

Similarly unstated in the Linux man page --- or any specification I
could find on the web --- is any mention about what happens if an
O_DIRECT write needs to allocate blocks; for example, because the write
is extending the size the file, or the write system call is writing into
a sparse file's "hole" where a block had not been previously
allocated. Current Linux implementations falls back to buffered I/O,
such that the data goes through the page cache. The current
implementation does wait until the I/O has been posted (although not
necessarily with a barrier such that the data is guaranteed written to
stable store by the storage device). However, Linux does not wait until
the metadata associated with the block allocation has been committed to
the filesystem; hence, if the system crashes after an extending write
completes, there is no guarantee the data will be accessible to an
application after the system reboots. To provide this guarantee, the
application must use fsync(2), or set the O_SYNC or O_DSYNC flag on the
file descriptor via fcntl(2).

Given that with an extending write, an explicit fsync(2) (or write with
O_SYNC/O_DSYNC) is required, there doesn't seem to be much point in
waiting until the data I/O is complete if the O_DIRECT write has fallen
back to using buffered I/O --- after all, if the data has been copied
into the page cache, the data buffered passed into the write(2) system
call can be safely reused for other purposes, so it may be that the
kernel should be allowed to return as soon as the data has been copied
into the page cache.

>From a specification point of view, the fact that extending writes can
fall back to buffered I/O should be documented, and that any file system
control data associated with the block I/O will not be synchronously
committed unless the application explicitly requests this via fsync(2)
or O_SYNC. If there is agreement that based on this, the kernel should
be allowed to return once the data buffer passed to write(2) can be
reused the application, this should be explicitly documented in the
open(2) man page as well.

== Writes into preallocated space == 

In recent Linux kernels, it is possible to request that the file system
allocate blocks with out initializing the blocks first. Since those
blocks contain previously unused data blocks, those blocks or extents
must be marked as uninitialized, so that reads of these uninitialized
blocks will return a zero block instead of the previous contents of
those blocks (which might cause a security exposure). The first time an
application writes into preallocated block, the file system must clear
the uninitialized bit, so that a subsequent read of that data block will
return the written data, instead of a zero block.

This requirement, when applied to a direct I/O write, has similar
implications to the extending write case, described above. Although the
space for the direct I/O has already been reserved, a change to the file
system metadata is required to mark the just-written data block or
extent as being initialized. For file systems that use a journal to
assure that the file system metadata is consistent, requiring direct I/O
write to block until a file system commit is completed would be an
unacceptable performance impact. On the other hand, if the data is not
guaranteed to be present after a system crash unless the application
uses an explicit fsync(2) call, this could take some application
programmers by surprise --- especially since testing that the
application data can be recovered after crashes that take place
immediately after an extending write or a write into a preallocated
block are cases that might not be well tested by all open source
database.

The proposed solution is the same for the extending writes; that we
document that O_DIRECT does not imply synchronous I/O of any file
control data, and that it is unspecified whether data written into newly
allocated blocks, or uninitialized regions of the file will survive a
system crash until the data is explicitly flushed to disk via a system
facility such as fsync(2). For that reason, the only thing which the
application can infer in the case of writes to preallocated
(uninitialized) file regions or file regions which require block
allocation is that when the write(2) system call, the data buffer passed
to write(2) may be reused for other purposes.

= Conclusion =

Most users of direct I/O will hopefully not be affected by the
clarifications in this document. These users tend to not to use
extending writes with Direct I/O, or are already using an explicit
fsync(2) after such extending writes. However, if there are applications
that have been making assumptions about direct I/O implying O_SYNC
semantics to meet (for example) database ACID requirements, changing
their application to meet the semantics documented herein (which after
all, is all applications have been getting anyway) should not be
difficult.

