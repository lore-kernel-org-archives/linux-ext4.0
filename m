From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 12:04:30 -0500
Message-ID: <20140107170430.GA2822@thunk.org>
References: <20140107025855.GA9229@birch.djwong.org>
 <20140107124831.GD16640@quack.suse.cz>
 <20140107154935.GA17609@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rob Browning <rlb@defaultvalue.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46633 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaAGREv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 12:04:51 -0500
Content-Disposition: inline
In-Reply-To: <20140107154935.GA17609@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 07:49:35AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 07, 2014 at 01:48:31PM +0100, Jan Kara wrote:
> >   I have to say I'm not thrilled by the idea of juggling strings in
> > userspace and in kernel to set a flag for an inode...
> 
> Nevermind the massive amounts of code that sit in the filesystem.

The reason for this patch was to address what Dave Chinner has called
"a shitty interface"[1].  Using bitfields that need to be coordinated
across file systems, when sometimes a bit assignment is validly a fs
specific thing, and then later becomes something that gets shared
across file systems.

[1] http://thread.gmane.org/gmane.linux.file-systems/80164/focus=80396

If we don't go about it this way, there are alternatives: we could
create new ioctls (or a new syscall) as we start running out of bits
used by FS_IOC_[GS]ETFLAGS.  We can create new ioctls for bits which
are intended for fs-specific flags, which then later get promoted to
the new syscall when some functionality starts to get shared accross
other file systems (probably with a different bit assignment).  This
is certainly less code, but it does mean more complexity outside of
the code when we try to coordinate new functionality across file
systems.

Personally, I don't mind dealing with codepoint assignments, but my
impression is that this is a minority viewpoint.  Al and Linus have
historically hated bitfields, and Al in the past has spoken favorably
of Plan 9's approach of using strings for the system interface.

So while I have a preference towards using bitfields, as opposed to
using the xattr approach, what I'd really like is that we make a
decision, one way or another, about what's the best way to move
forward.

   	    	     	      	      	  - Ted
