From: Theodore Tso <tytso@mit.edu>
Subject: Re: How to fix up mballoc
Date: Thu, 23 Jul 2009 20:43:24 -0400
Message-ID: <20090724004324.GB14052@mit.edu>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com> <20090723134538.GC8040@mit.edu> <4A68A33E.4050103@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40501 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZGXAnj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 20:43:39 -0400
Content-Disposition: inline
In-Reply-To: <4A68A33E.4050103@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 23, 2009 at 10:51:58AM -0700, Mingming Cao wrote:
> I am trying to understand what user cases prefer normalize allocation  
> request size? If they are uncommon cases, perhaps
> we should disable the normalize the allocation size disabled by default,  
> unless the apps opens the files with O_APPEND?

The case where we would want to round the allocation size up would be
if we are writing a large file (say, like a large mp3 or mpeg4 file),
which takes a while for the audio/video encoder to write out the
blocks.   In that case, doing file-based preallocation is a good thing.

Normally, if we are doing block allocations for files greater than 16
blocks (i.e, 64k), we use file-based preallocation.  Otherwise we use
block group allocations.  The problem with using block group
allocations is that way it works is that first time we try to allocate
out of a block group, we try to find a free extent which is 512 blocks
long.  If we can't find a free extent which is 512 blocks long, we'll
try another block group.  Hence, for small files, once a block group
gets fragmented to the point where there isn't a free chunk which is
512 blocks long, we'll try to find another block group --- even if
that means finding another block group far, FAR away from the block
group where the directory is contained.

Worse yet, if we unmount and remount the filesystem, we forget the
fact that we were using a particular (now-partially filled)
preallocation group, so the next time we try to allocate space for a
small file, we will find *another* free 512 block chunk to allocate
small files.  Given that there is 32,768 blocks in block group, after
64 interations of "mount, write one 4k file in a directory, unmount",
that block group will have 64 files, each separated by 511 blocks, and
that block group will no longer have any free 512 chunks for block
allocations.  (And given that the block preallocation is per-CPU, it
becomes even worse on an SMP system.)

Put this baldly, it may be that we need to do a fundamental rethink on
how we do per-cpu, per-blockgroup preallocations for small files.
Maybe instead of trying to find a 512 extent which is completely full,
we should instead be looking for a 512 extent which has at least
mb_stream_req free blocks (i.e. by default 16 free blocks).

	      	   	  	   	      	   - Ted
