From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How to fix up mballoc
Date: Thu, 23 Jul 2009 12:43:47 -0500
Message-ID: <4A68A153.8030804@redhat.com>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com> <20090723134538.GC8040@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZGWRnx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 13:43:53 -0400
In-Reply-To: <20090723134538.GC8040@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> So I started looking to see how we might be able to improve mballoc to
> avoid freespace fragmentation, and I came up with the following high
> level design.  Does this look sane?   Have I overlooked anything?
> 
> 1) In ext4_mb_normalize_request(), if the inode that we are allocating
> does not have any open file descriptors for write (i.e., it's already
> closed and we're allocating via delalloc) _and_ the inode was
> previously opened with O_CREAT and without O_APPEND (checked via a
> flag in EXT4_I(inode)), then do not normalize the size to a power of
> two, but rather to the filesystem blocksize.
> 
> The idea here is that we should be trying to find an exact fit, since
> most of the time (except for log files, which get appended; hence the
> O_CREAT && !O_APPEND test) once a file is written, that is probably
> the final size for the file.  So normalizing the size for the
> preallocation area to a power of two will be counterproductive for
> most files.

I'm sort of woefully ignorant of a lot of the mballoc stuff.

When you say once a file is written that's probably the final size... do
you mean when writes are done and it's closed, or when the first write
to the file is complete?

I think an awful lot of normal cases write to a file in sub-file-sized
chunks (think mp3 or flac encoding, file downloading, etc).

Also, I get the !O_APPEND test, but is O_CREAT necessary?  I wonder how
much of a hint that really gives us.

> 2) If the there has been less than X files opened in Y jiffies the
> parent directory (using the dentry path used to open the file), then
> do not set EXT4_MB_HINT_GROUP_ALLOC in ext4_mb_group_or_file().  We
> can simulate this for without creating this patch to test #1 by
> setting mb_stream_request to 0 (which should completely disable group
> preallocation).

Hm have to try hard to parse that ;)  But that sounds reasonable I think.

I'm talking to the Fedora infrastructure folks to see if there's a way
to recreate snapshots of, say, the F10 repos from initial release to
today, to be able to sort of fast-forward root filesystem updates.  It'd
be a nice way to do accelerated aging tests for any changes we make, at
least for one usecase ...

-Eric

> 						- Ted
