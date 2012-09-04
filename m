From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Mon, 3 Sep 2012 23:29:19 -0400
Message-ID: <20120904032919.GJ5066@thunk.org>
References: <20120903220213.GE19158@chaosreigns.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: darxus@chaosreigns.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48694 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab2IDD3W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 23:29:22 -0400
Content-Disposition: inline
In-Reply-To: <20120903220213.GE19158@chaosreigns.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 03, 2012 at 06:02:13PM -0400, darxus@chaosreigns.com wrote:
> [732715.730069] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0: ix (10742) != EXT_FIRST_INDEX (0)
> [  496.347230] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0:ix (10742) != EXT_FIRST_INDEX (0)
> 
> What is the significance of this file?  What does the error mean?

The error means that the metadata associated with one of Chromium's
cache files had gotten corrected.  You say you saw this exact same
error separated in time by three months.  Between those three months,
was the file system corruption fixed by an e2fsck run?

If not, the fact that you are getting this message twice isn't
surprising.  The e2fsck program *should* have been run at each reboot,
but this error may have required manual intervention to fix up.

If you did run e2fsck, and the file system corruptions was fixed
between the two times that you saw the EXT4-fs error message, then
that is very interesting.  I would discount scribbling over kernel
memory, since it would be pretty unusual that the exact same inode and
the exact same block had gotten corrupted in exactly the same way.  It
could be a bug in the graphics driver, perhaps triggered by the way
Wayland is using said graphics driver.

That also seems fairly hard to credit, so I'm going to hope you didn't
actually run e2fsck to fix the file system corruption....

	     	       	       	    	   - Ted
