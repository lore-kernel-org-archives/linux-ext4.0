From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] Add stack I/O manager.
Date: Fri, 18 May 2007 23:31:00 -0400
Message-ID: <20070519033100.GB8654@thunk.org>
References: <11786983382211-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36030 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400AbXESGQp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 May 2007 02:16:45 -0400
Content-Disposition: inline
In-Reply-To: <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 09, 2007 at 01:42:17PM +0530, Aneesh Kumar K.V wrote:
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> This I/O manager helps in stacking different I/O managers.
> For example one can stack the undo I/O manager on top
> of Unix I/O manager to achieve the undo functionality.

This is probably more generality than is strictly necessary; and the
place where the excess generality gets messy is the fact that you make
the stacking layer responsible for calling all of the io manager's
open routines (which is still a FIXME).  So I would flush the stack_io
layer entirely.

What I would recommend as the fast and dirty approach.  Basically, ape
the approach used by test_io layer _exactly_, except instead of using
a global variable test_io_backing_manager, you provide a function
which sets the static variable, undo_io_backing_manager.  This
variable is used only by the subsequent call to the ->open method,
which just like test_io simply passes the name down to the backing
manager specified in the static variable.  Then just make the undo_io
manager work the way test_io does, where does its thing, and then it
calls the appropriate function in its private->real io_channel.
Basically, make undo_io responsible for calling the next io_manager
down in the chain, This is workable because we don't need to
initialize the tdb file until we first try to write to the io_channel,
and ext2fs_open() only needs to do read operations, so we can set the
tdb filename via an optoin after ext2fs_open() returns.

I could imagine a more complicated approach where we still wouldn't
have a stacking layer, but have an integrated parsing layer which
would have registered names for each of the io_managers.  It would
then take the part of the name before the colon, and treat it as the
type (i.e., "file"), and the part after the colon and pass it to the
relevant's io_manager (i.e., "/dev/sda4").  So you could pass in a
name like "file:/dev/sda4".   

For the test_io manager, since it doesn't need any arguments, it could
just take the part after the colon, and use it to pass back to the
parsing layer.  So names to test_io manager would look like this:
"test:file:/dev/sda4".

For managers that need two names, we would have to do something a bit
more complicated, like this: "undo:/var/undo/tdbfile#file:/dev/sda4".
But basically, we still make the stacking up to the individual
io_manager.  The main advantage with this approach is that all of the
stacking is done via the ASCII string provided by the user, and
there's no need for any special ad-hoc options.

On the other hand, arguably, you want the program decided where to put
the undo file, so that it can be found automatically by e2fsck.  So
the fast-and-dirty approach might be the better one anyway --- it
certainly is easier!

Regards,
	
						- Ted
