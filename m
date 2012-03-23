From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] libext2fs: Implement
 ext2fs_find_first_zero_generic_bmap().
Date: Fri, 23 Mar 2012 18:33:31 -0400
Message-ID: <20120323223331.GA8554@thunk.org>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213740.GO6961@sli.dy.fi>
 <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca>
 <20120312191514.GS6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47054 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab2CWWdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2012 18:33:36 -0400
Content-Disposition: inline
In-Reply-To: <20120312191514.GS6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 12, 2012 at 09:15:14PM +0200, Sami Liedes wrote:
> In the case of ext2fs_new_inode(), the function does not actually
> iterate through all zero bits; it really only wants to find the first
> zero in a certain range, after which it returns. So for simplicity of
> use (and efficiency) I think it still makes sense to have
> ->find_first_zero() too.

I agree, a find_first_zero() and a find_first_set(), both of which
taking a starting bit position for the search, and the best low-level
primitives that would be implemented on for each backend bitmap
implementation.

It would then be very easy to build iterators on *top* of
find_first_zero() and find_first_set(), and in fact this could be used
to replace some of the places where we are using a sorted list (i.e.,
the badblocks list).  So that sounds like a good idea, and I can
definitely think of some places where we could use that code today.

So I plan to pull in your patch series and then we can further enhance
this with iterator support afterwards.  Sami, if you'd be interested
in implementing iterators, that would be great!

Thanks,

   			   	      	 - Ted
