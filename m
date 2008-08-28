From: Theodore Tso <tytso@mit.edu>
Subject: Re: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 16:35:53 -0400
Message-ID: <20080828203553.GB10082@mit.edu>
References: <48B6BD02.3080307@redhat.com> <20080828184804.GN26987@mit.edu> <48B6F69C.3090700@redhat.com> <20080828200448.GQ3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43593 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754023AbYH1Uf4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 16:35:56 -0400
Content-Disposition: inline
In-Reply-To: <20080828200448.GQ3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 02:04:48PM -0600, Andreas Dilger wrote:
> 
> I think there is little benefit to fixing each program to do sorting.
> Either your LD_PRELOAD library should become more standard (e.g. put
> into glibc)

Yeah, but that requires dealing with Ulrich and for my own mental
health I try to avoid that as much as possible.  :-)

This idea is something that has been in my "if only I had time or some
minions to dispatch" category for quite some time.  We can actually do
this in the kernel.

For small directories which could potentially get converted into htree
format, we already sucking the entire directory and putting it into an
rbtree.  We could just do this for all directories less than or equal
to 32k, but have them returned sorted by inode instead of by hash
value.  At least on my laptop, this accounts for 99.93% of the
directories on my root filesystem.

There are some fancy things that would have to be done to make
telldir/seekdir, but the basic idea is pretty simple.

		     	       	       	      - Ted
