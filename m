From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 6 Apr 2012 13:06:11 -0700
Message-ID: <20120406200611.GA11295@thunk.org>
References: <20120330125726.GA26221@amd.home.annexia.org>
 <20120330131936.GB26221@amd.home.annexia.org>
 <4F760BC2.4070401@redhat.com>
 <20120406191401.GA8816@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44728 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab2DFUGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 16:06:11 -0400
Content-Disposition: inline
In-Reply-To: <20120406191401.GA8816@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was flying back from San Francisco so I decided to take a look at
this while I was flying back.  So my patches overlapped with yours....

I think mine will be a tad bit faster for the fallback path since we
don't end up doing the 32-bit/64-bit each time we test a bit (since I
created a 32-bit and 64-bit ffz function). 

On Fri, Apr 06, 2012 at 10:14:01PM +0300, Sami Liedes wrote:
> 
> Argh, indeed. I thought the 32-bit bitfields also have the bitmap_ops
> field (and in the same offset), but they don't.

Yeah, the only thing which is the same is the offset.  The structure
definition is in gen_bitmap.c and gen_bitmap64.c, and they are
different depending on whether it is a 32-bit or 64-bit bitmap.

> > I am a little confused by the existence of two different
> > struct ext2fs_struct_generic_bitmap's in the code.  But treating one as the
> > other looks doomed to failure ;)
> 
> In addition to that, there are actually three different versions of
> many operations; they are named ext2_foo_bmap(), ext2_foo_bitmap() and
> ext2_foo_bitmap2(). I'm quite confused too.

Well, actually there are four.  The original 32-bit code has generic
bitmap code that is where most of the implementation exists.  Then we
have separate versions for block and inode bitmaps for the purposes of
type checking.

Then in the 64-bit code, we have the same thing; generic versions plus
block/inode specific versions, plus of course the multiple different
back-end implementations.

I've added test cases to exercise all of this code, which should
prevent problems in the future.  I expect that after we add a
find_first_set function, it's unlikely we'll need to be touching the
bitmap implementations again for the near future....

       		       	     	     	  - Ted
