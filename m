From: Zach Brown <zab@redhat.com>
Subject: buggy readdir with inline dirs
Date: Fri, 22 Mar 2013 11:26:08 -0700
Message-ID: <20130322182608.GT10038@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <boyu.mt@taobao.com>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655Ab3CVS0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Mar 2013 14:26:13 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I don't remember quite how, but I found myself flipping through the
inline dir code that's in mainline now.  It looked pretty fishy so Eric
and I played around with it.  It's very buggy in its current form.

ext4_read_inline_dir() doesn't seem to undertand the filldir arguments.
It suggests that offset 0 is the next offset after both the "." and ".."
entries.  It needs to have specific offsets for "." and ".." and return them
accordingly.  It looks like fixing this will trickle down into the
revalidation loop.

It doesn't understand that it's possible to only return a single "."
entry in getdents and have a subsequent call have f_pos pointing at the
fake ".." entry.  With the current code if your getdents buffer only has
room for "." it just spins returning that entry leaving f_pos at 0.

Those are all relatively simple bugs that just need to be fixed.

But the big bug is that it changes the d_off values for entries as it
converts from byte offsets in the inline dir xattr to hashed offsets in
indexed dir leaves.  A concurrent readdir could be unlucky enough to get
a bunch of duplicate entries as it reads past the nice low inline byte
offsets into the huge hashed offsets.

I'm not sure how to easily fix that.  It feels like it'd want to
maintain the dir entries in the xattr blob with the offsets that they'll
have once converted to full dir blocks.  So instead of being a magical
readdir path maybe it wants to be in the path of looking up dir blocks
so existing unindexed and indexed code would operate on the data in the
xattr blob as though it were a block?

Dunno, just wanted to share what we found.  Are these all known problems
in prototype code that isn't intended to be used?

- z
