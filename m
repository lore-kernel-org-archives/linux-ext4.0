From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 22 Jul 2009 09:24:37 -0700
Message-ID: <1248279877.14463.7.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:21120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZGVQZA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jul 2009 12:25:00 -0400
In-Reply-To: <20090721215421.GM4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:
> On Jul 21, 2009  14:29 -0700, Frank Mayhar wrote:
> > I've spent a little while today digging into this.  My guess (only a
> > guess at this point until I have a chance to prove it) is that
> > i_disksize should be updated by fallocate() even when KEEP_SIZE is
> > specified.  It's currently not updated in that case.
> 
> No, that isn't correct.  The intent of KEEP_SIZE is to allow fallocate
> to preallocate blocks beyond the EOF, so that it doesn't affect the
> file data visible to userspace, but can avoid fragmentation from e.g.
> log files or mbox files.
> 
> The i_disksize variable is just to handle the lag in updating the on-disk
> file size during truncate, because the VFS updates i_size to indicate a
> truncate, but in order to handle the truncation of files within finite
> transaction sizes the on-disk file size needs to be shrunk incrementally.

Okay, thanks, this makes this much more clear.

It does sound like there needs to be a flag somewhere (probably in the
on-disk inode) that indicates that there are allocated blocks beyond
EOF, as you say.  Then use that in ftruncate().

We would really like to avoid your workaround for performance reasons.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

