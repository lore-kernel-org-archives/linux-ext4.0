From: tytso@mit.edu
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Date: Mon, 5 Jul 2010 13:27:18 -0400
Message-ID: <20100705172718.GE25518@thunk.org>
References: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
 <4C32001F.8060906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C32001F.8060906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 05, 2010 at 10:54:07AM -0500, Eric Sandeen wrote:
> 
> ... a stern comment here about not re-ordering since other fs/*/*
> code depends strongly on this order?

A stern warning is needed there, but it's also needed a few lines
further down in the inode flags section where the FS_*_FL flags are
defined.  These were originally ext2-specific inode flags, and it's
become generalized to a fs-independent set of bit fields, but what's
nasty/important to remember is that these flags are also used as
on-disk flags for ext2/3/4, and so extreme care is needed before new
flags are for FS_IOC_GETFLAGS/FS_IOC_SETFLAGS are allocated....

In fact, I'd argue it's much more strongly needed for the FS_*_FL
flags.

						- Ted
