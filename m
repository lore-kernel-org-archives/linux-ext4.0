From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 21:07:59 -0500
Message-ID: <20131219020759.GA27469@thunk.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218050127.GA15289@thunk.org>
 <20131218142749.GA9207@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131218142749.GA9207@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 18, 2013 at 07:27:49AM -0700, Matthew Wilcox wrote:
> 
> I think there is a callback in xip_file_write(), and it's get_xip_mem().
> From what you're saying, it sounds like it's just not doing enough.

The problem is that git_xip_mem() is called before we write to the
memory, right?

We need to convert the uninit extents to be marked as initialized in
*after* the write has been sent to the storage medium.

> Could you take pity on me and tell me what flags I need to check in the
> buffer_head to determine this state of affairs?

The buffer head flag is BH_Unwritten, but note that how BH_Delay and
BH_Boundary are handled is very file system specific.  There is no
guarantee that all file systems will use these flags, nor will use
them in the same way.  (I've been considering changing ext4 to not
attach buffer heads to the pages at all -- except for DIO, which
requires them today -- because iterating over all of the buffer heads
attached to the pages is a pain in the tuckus, and ext4 now has an
extent status tree which we could use to get this information without
needing to lock the pages.)

It's much better to give a way for the file system to attach a
callback to the XIP request object.

Cheers,

						- Ted
