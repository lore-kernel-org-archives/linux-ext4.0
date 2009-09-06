From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
	in  failure
Date: Sat, 5 Sep 2009 23:37:15 -0400
Message-ID: <20090906033715.GF3055@mit.edu>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com> <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com> <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com> <4AA0E419.7010707@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peng Tao <bergwolf@gmail.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39555 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbZIFDhR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 23:37:17 -0400
Content-Disposition: inline
In-Reply-To: <4AA0E419.7010707@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 06:55:37PM +0900, Akira Fujita wrote:
> 
> More test cases are needed for EXT4_IOC_MOVE_EXT,
> so this patch may not be complete,
> but the problem you reported is fixed at least.
> I am now testing EXT4_IOC_MOVE_EXT hard.

I've not added this patch to the patch queue, yet, based on the fact
that are still doing more testing and Pen Tao seems to have found more
issues.

I have applied your original four patches since I've looked over the
patches and they look good.

Two comments I have of the move_extents() code; it would be preferable
if you replace BUG_ON calls with a call to ext4_error(); that way
instead of crashing the entire kernel, you print an error and then
stop making changes to the file system in question.  Users will be
much happier if the system doesn't completely crash, and it also
becomes easier to grab the system messages after an ext4_error(),
compared to BUG_ON().   

Secondly, it would be really nice to replace get_ext_path() with an
inline function.  The problem with get_ext_path() is that for someone
who is just reading through the code it looks like a function call,
but the first and fourth arguments get modified.  But if someone
doesn't jump up to the beginning of the call, this isn't obvious.

If I can't look at the #define, it's not obvious that orig_path and
err will be modified.

	get_ext_path(orig_path, orig_inode, eblock, err);

A calling path like this is much more obvious:

	err = get_ext_path(orig_inode, eblock, &orig_path);

See?  Just one look at the 2nd calling pattern makes it obvious that
err and orig_path functions will be modified.  And returning the error
code (as a negative errno code) is a common calling convention used in
the kernel.

Rusty's slides about interface design are especially good to review in
this context:

	http://ozlabs.org/~rusty/ols-2003-keynote/img27.html

(His whole slide deck are good to review, but this section is
especially valuable.)

						- Ted
