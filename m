From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: journal all modifications in
	ext4_xattr_set_handle
Date: Fri, 6 Nov 2009 21:33:41 -0500
Message-ID: <20091107023341.GF26342@mit.edu>
References: <4AF4A334.1000304@redhat.com> <4AF4A49F.8030005@redhat.com> <55C0D494-12AD-4EF7-8C35-411B2B5151EF@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33772 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZKGCdj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 21:33:39 -0500
Content-Disposition: inline
In-Reply-To: <55C0D494-12AD-4EF7-8C35-411B2B5151EF@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2009 at 05:22:51PM -0700, Andreas Dilger wrote:
> On 2009-11-06, at 15:35, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> ext4_xattr_set_handle() was modifying s_inode_size outside
>>> of journaling constraints; this is one of the accesses that
>>> was causing the crc errors in journal replay as seen in
>>> kernel.org bugzilla #14354.
>>
>> Oh, and for those who haven't been following the bug, big
>> thanks to Chris Mason for helping to look into this and coming
>> up with the debugging patch that made it obvious...
>
> It would be great, IMHO, to have this debugging patch submitted to
> the kernel also, and enabled under a CONFIG option.

The debugging patch is only safe when the file system's block size ==
page size.  I suppose we could leave a warning in Kconfig that the
debugging option is only safe to be used when all of the file systems
in the system have a 4k (or whatever the page size happens to be)
block size, but it's probably better to clean up the patch so that
it's only enabled on a mount option, and then only if the file system
block size is the same as the page size.

> I'd also be interested to see the "write shadow buffer to journal"
> one-line patch that was discussed in the bug.

Which patch are you referring to?

					- Ted
