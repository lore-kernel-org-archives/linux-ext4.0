From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 1/7] manpage for fallocate
Date: Wed, 11 Jul 2007 01:48:20 +0530
Message-ID: <20070710201820.GA8797@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:55235 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbXGJUSQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 16:18:16 -0400
Content-Disposition: inline
In-Reply-To: <20070710201200.GA10255@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Following is the modified version of the manpage originally submitted by
David Chinner. Please use `nroff -man fallocate.2 | less` to view.


.TH fallocate 2
.SH NAME
fallocate \- allocate or remove file space
.SH SYNOPSIS
.nf
.B #include <sys/syscall.h>
.PP
.BI "int syscall(int, int fd, int mode, loff_t offset, loff_t len);
.Op
.SH DESCRIPTION
The
.BR fallocate
syscall allows a user to directly manipulate the allocated disk space
for the file referred to by
.I fd
for the byte range starting at
.IR offset
and continuing for
.IR len
bytes.
The
.I mode
parameter determines the operation to be performed on the given range.
Currently there are four modes:
.TP
.B FALLOC_ALLOCATE
allocates and initialises to zero the disk space within the given range.
After a successful call, subsequent writes are guaranteed not to fail because
of lack of disk space.  If the size of the file is less than
.IR offset + len ,
then the file is increased to this size; otherwise the file size is left
unchanged.
.B FALLOC_ALLOCATE
closely resembles
.B posix_fallocate(3)
and is intended as a method of optimally implementing this function.
.B FALLOC_ALLOCATE
may allocate a larger range that was specified.
.TP
.B FALLOC_RESV_SPACE
provides the same functionality as
.B FALLOC_ALLOCATE
except it does not ever change the file size. This allows allocation
of zero blocks beyond the end of file and is useful for optimising
append workloads.
.TP
.B FALLOC_DEALLOCATE
removes any preallocated space within the given range. The file size
may change if deallocation is towards the end of the file.
.TP
.B FALLOC_UNRESV_SPACE
removes the underlying disk space within the given range. The disk space
shall be removed regardless of it's contents so both allocated space
from
.B FALLOC_ALLOCATE
and
.B FALLOC_RESV_SPACE
as well as from
.B write(3)
will be removed.
.B FALLOC_UNRESV_SPACE
shall never remove disk blocks outside the range specified.
.B FALLOC_UNRESV_SPACE
shall never change the file size. If changing the file size
is required when deallocating blocks from an offset to end
of file (or beyond end of file) is required,
.B ftuncate64(3)
or
.B FALLOC_DEALLOCATE
should be used.

.SH "RETURN VALUE"
.BR fallocate()
returns zero on success, or an error number on failure.
Note that
.IR errno
is not set.
.SH "ERRORS"
.TP
.B EBADF
.I fd
is not a valid file descriptor, or is not opened for writing.
.TP
.B EFBIG
.I offset+len
exceeds the maximum file size.
.TP
.B EINVAL
.I offset
or
.I len
was less than 0.
.TP
.B ENODEV
.I fd
does not refer to a regular file or a directory.
.TP
.B ENOSPC
There is not enough space left on the device containing the file
referred to by
.IR fd.
.TP
.B ESPIPE
.I fd
refers to a pipe of file descriptor.
.B ENOSYS
The filesystem underlying the file descriptor does not support this
operation.
.SH AVAILABILITY
The
.BR fallocate ()
system call is available since 2.6.XX
.SH "SEE ALSO"
.BR syscall (2),
.BR posix_fadvise (3)
.BR ftruncate (3)
