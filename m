From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: mkfs.ext4 -D option fails to mount
Date: Thu, 29 Jun 2017 13:53:19 -0400
Message-ID: <20170629175319.s75rdncvejil357p@thunk.org>
References: <20170629153538.GA4268@linux.intel.com>
 <20170629155727.GA8536@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59354 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751936AbdF2RxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Jun 2017 13:53:22 -0400
Content-Disposition: inline
In-Reply-To: <20170629155727.GA8536@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 29, 2017 at 09:57:27AM -0600, Ross Zwisler wrote:
> On Thu, Jun 29, 2017 at 09:35:38AM -0600, Ross Zwisler wrote:
> > Our validation team noticed that in some configurations mkfs.ext4 with the
> > -D option creates a filesystem that can't be mounted:

The -D option just means that we're doing the I/O using Direct I/O (as
opposed to buffered I/O).  It shouldn't make any difference to what
gets written, so this very much smells like a bug in how /dev/pmem
supports Direct I/O...

> One more bit of info - this seems to be strongly tied to the size of the
> block device.  With a 32 GB block device it works fine, with 248 GB you get
> overlap messages for groups 1 through 63, and with a 250 GB device you get
> overlaps for groups 1 through 1999.

This very much sounds like Direct I/O is just getting completely
botched for the pmem device, and writes to a block group descriptor
block is affecting the wrong place on the storage device.

      	 	       	     	      - Ted
