From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] Add flag to ext2fs_flush and ext2fs_close to
 avoid fsync.
Date: Sat, 24 Sep 2011 12:53:50 -0400
Message-ID: <20110924165350.GC2779@thunk.org>
References: <20110923102342.GC31740@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, berrange@redhat.com
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40389 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1IXQxw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Sep 2011 12:53:52 -0400
Content-Disposition: inline
In-Reply-To: <20110923102342.GC31740@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 11:23:42AM +0100, Richard W.M. Jones wrote:
> [Hopefully sent to the right place this time ...]
> 
> This patch allows users of the ext2fs library to avoid doing an fsync
> on close (obviously this is optional, and doesn't affect existing callers).
> 
> Where this helps us is when constructing a throwaway ext2 filesystem
> just to boot a virtual machine.  By avoiding the 2 x fsync, we save
> over 5 seconds and many many unnecessary disk writes.

Added to the e2fsprogs next branch, thanks.  It will be part of the
e2fsprogs 1.42 release.

						- Ted
