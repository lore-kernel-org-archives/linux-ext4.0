From: Theodore Tso <tytso@mit.edu>
Subject: Re: Porting Zfs features to ext2/3
Date: Sun, 27 Jul 2008 18:49:58 -0400
Message-ID: <20080727224958.GB7922@mit.edu>
References: <18674437.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: postrishi <postrishi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:32979 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbYG0WuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 18:50:04 -0400
Content-Disposition: inline
In-Reply-To: <18674437.post@talk.nabble.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2008 at 01:49:53AM -0700, postrishi wrote:
> I want to know that has any work been done to port the Zfs features to
> ext2/3

There are some new features in ext4, but the primary goal of ext4
development is to improve the filesystem by adding features such as
extents, delayed allocation, etc., in an evolutionary way, so that an
existing ext3 filesystem could be upgraded to ext4.  So the primary
goal is not to try to complete with the ZFS features set.

The btrfs filesystem effort is an attempt to create a filesystem that
will leapfrog the ZFS feature set, but it will probably take longer to
reach production ready status than ext4.

Regards,

						- Ted
