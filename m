From: Dave Chinner <david@fromorbit.com>
Subject: Re: buggy readdir with inline dirs
Date: Sat, 23 Mar 2013 12:02:19 +1100
Message-ID: <20130323010219.GE6369@dastard>
References: <20130322182608.GT10038@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60197 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422667Ab3CWBCX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Mar 2013 21:02:23 -0400
Content-Disposition: inline
In-Reply-To: <20130322182608.GT10038@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 22, 2013 at 11:26:08AM -0700, Zach Brown wrote:
> I don't remember quite how, but I found myself flipping through the
> inline dir code that's in mainline now.  It looked pretty fishy so Eric
> and I played around with it.  It's very buggy in its current form.
> 
> ext4_read_inline_dir() doesn't seem to undertand the filldir arguments.
> It suggests that offset 0 is the next offset after both the "." and ".."
> entries.  It needs to have specific offsets for "." and ".." and return them
> accordingly.  It looks like fixing this will trickle down into the
> revalidation loop.
> 
> It doesn't understand that it's possible to only return a single "."
> entry in getdents and have a subsequent call have f_pos pointing at the
> fake ".." entry.  With the current code if your getdents buffer only has
> room for "." it just spins returning that entry leaving f_pos at 0.
> 
> Those are all relatively simple bugs that just need to be fixed.
> 
> But the big bug is that it changes the d_off values for entries as it
> converts from byte offsets in the inline dir xattr to hashed offsets in
> indexed dir leaves.  A concurrent readdir could be unlucky enough to get
> a bunch of duplicate entries as it reads past the nice low inline byte
> offsets into the huge hashed offsets.
> 
> I'm not sure how to easily fix that.  It feels like it'd want to
> maintain the dir entries in the xattr blob with the offsets that they'll
> have once converted to full dir blocks.  So instead of being a magical
> readdir path maybe it wants to be in the path of looking up dir blocks
> so existing unindexed and indexed code would operate on the data in the
> xattr blob as though it were a block?

XFs solves this problem by keeping an "offset" field in the
short-form directory entry. It calculates what the offset would be
if the entry was in block form and adds that to the directory entry
so that when the directory grows to block form and the entries are
moved,they retain the same userspace visible offset. The offsets
returned to getdents/readdir are what is in the offset field, not
the physical offset of then entry in the shortform structure...

A similar (but opposite) process takes place when going from block
form back to short form....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
