From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 10/10] debugfs: use the functions in misc/util.c
Date: Mon, 14 Oct 2013 10:40:12 -0400
Message-ID: <20131014144012.GA26576@thunk.org>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
 <1377667560-20089-11-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45931 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab3JNOkQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Oct 2013 10:40:16 -0400
Content-Disposition: inline
In-Reply-To: <1377667560-20089-11-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 01:26:00PM +0800, Robert Yang wrote:
> Use the functions in mist/util.c to reduce the duplicated code.

This patch conflicts with an earlier patch you had sent which allowed
copy_file() to handle sparse files.

Also, could you move all of the functions which you added to
misc/util.c to a new file, named something like misc/create_inode.c,
or something like that?

That will avoid bloating the tune2fs binary, which won't need any of
these new functions.

Eventually, I plan to rename libquota to libinternal, and use it for
internal functions used by e2fsprogs, and at that point we'll move
misc/util.c, e2fsck/profile.c, and the functions for creating inodes
into this libinternal library.

But for now, if you could organize these functions into a one or more
separate .c files, and leave them in the misc directory, that would be
great.

Thanks!!

					- Ted
