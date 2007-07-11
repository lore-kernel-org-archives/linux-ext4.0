From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] manpage for fallocate
Date: Wed, 11 Jul 2007 14:42:24 +0530
Message-ID: <20070711091224.GA30545@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710201820.GA8797@amitarora.in.ibm.com> <20070710213701.GG3400@zakalwe.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Heikki Orsila <shdl@zakalwe.fi>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070710213701.GG3400@zakalwe.fi>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 12:37:01AM +0300, Heikki Orsila wrote:
> On Wed, Jul 11, 2007 at 01:48:20AM +0530, Amit K. Arora wrote:
> > .BI "int syscall(int, int fd, int mode, loff_t offset, loff_t len);
> 
> Correction: "int syscall(int fd, int mode, ...)",

Here, we have syscall() with first argument being the system call number
- so what you suggested is not correct.

But, yes, the synopsis should change at some time. Maybe to something
like:

	#include <fcntl.h>

	long fallocate(int fd, int mode, loff_t offset, loff_t len);

> > .TP
> > .B ENOSPC
> > There is not enough space left on the device containing the file
> > referred to by
> > .IR fd.
> > .TP
> > .B ESPIPE
> > .I fd
> > refers to a pipe of file descriptor.
> > .B ENOSYS
> > The filesystem underlying the file descriptor does not support this
> > operation.
> 
> EINTR?

Will add following errors:

  EINTR		A signal was caught during execution
  EIO		An I/O error occurred while reading from or writing to
		a file system.
  EOPNOTSUPP	The mode is not supported on the file descriptor.

and will update following :

  EINVAL	offset was less than 0, or len was less than or equal to 0.

--
Regards,
Amit Arora
