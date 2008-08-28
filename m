From: Theodore Tso <tytso@mit.edu>
Subject: Re: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 18:34:54 -0400
Message-ID: <20080828223454.GD10082@mit.edu>
References: <48B6BD02.3080307@redhat.com> <20080828184804.GN26987@mit.edu> <48B6F69C.3090700@redhat.com> <20080828200448.GQ3392@webber.adilger.int> <20080828203553.GB10082@mit.edu> <20080828222348.GS3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40945 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755590AbYH1We5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 18:34:57 -0400
Content-Disposition: inline
In-Reply-To: <20080828222348.GS3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 04:23:48PM -0600, Andreas Dilger wrote:
> > For small directories which could potentially get converted into htree
> > format, we already sucking the entire directory and putting it into an
> > rbtree.  We could just do this for all directories less than or equal
> > to 32k, but have them returned sorted by inode instead of by hash
> > value.  At least on my laptop, this accounts for 99.93% of the
> > directories on my root filesystem.
> 
> What happens if the directory is grown at that point?  I thought the
> reason for keeping it sorted in hash order was to deal with the
> telldir headache?  I guess if the whole thing is in memory then it
> can be attached to the fd and discarded once read or seeked-on
> (and POSIX doesn't require reporting new entries after the start
> of the read).

It's fine, because according to POSIX it's undefined what happens to
files that are created or deleted after the last opendir() or
rewindir().  So basically, the b-tree is attached to the opendir, and
we discard it and re-create it if we ever seek to the beginning of the
directory.  This logic is already in the kernel, since it's exactly
the same situation if the file is grown past the point where it
becomes an HTREE directory.

> Doing this at the VFS level would also benefit _most_ filesystems,
> though maybe not ones like XFS or btrfs that have their own preferred
> order.

Possibly, but it's a lot easier inside ext3/ext4 because we have most
of the machinery in place and in use already.

	              		    	      - Ted
