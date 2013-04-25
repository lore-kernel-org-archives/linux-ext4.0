From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: allow 0-length xattr values in e2fsck
Date: Thu, 25 Apr 2013 00:20:01 -0400
Message-ID: <20130425042001.GA4685@thunk.org>
References: <5161BE0A.5070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	David Shaw <dshaw@jabberwocky.com>,
	Harald Reindl <h.reindl@thelounge.net>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44388 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab3DYEUN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Apr 2013 00:20:13 -0400
Content-Disposition: inline
In-Reply-To: <5161BE0A.5070003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 07, 2013 at 01:42:18PM -0500, Eric Sandeen wrote:
> e2fsck thinks that this:
> 
> # touch mnt/testfile1
> # setfattr -n "user.test" mnt/testfile1
> 
> results in a filesystem with corruption:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Extended attribute in inode 12 has a value size (0) which is invalid
> Clear? yes
> 
> but as far as I can tell, there is absolutely nothing wrong with
> a 0-length value on an extended attribute.  Just remove the check.
> 
> Reported-by: David Shaw <dshaw@jabberwocky.com>
> Reported-by: Harald Reindl <h.reindl@thelounge.net>
> Addresses-Red-Hat-Bugzilla: #557959
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

It turns out that 0-length values applied for xattrs stored in
external xattr blocks.  0-length xattrs were only only getting
prohibited for in-inode xattrs.

						- Ted
