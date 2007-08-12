From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Future of ext2 support in the Hurd?
Date: Sun, 12 Aug 2007 17:40:00 -0400
Message-ID: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: bug-hurd@gnu.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42171 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933595AbXHLVkl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 17:40:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi there,

There was recent discussion of taking out support for "dead" OS's and
features in e2fsprogs, such as fragmentation, support for the Masix
OS.... and Hurd.  So in the interests of doing some research to see
whether or not Hurd was really completely dead, or just "mostly dead"
(to in the Princess Bride sense :-), I did some digging, and found this
list.

There is an awful lot of out-of-date and extremely cobwebby pages out
there on the web, but it looks like even there are some people working
on it.  Am I right in my assumption that no one even though no one
touched the ext2 code in two years, with the bulk of the files in CVS
not having been touched in seven years, that there are still people
using the ext2 filesystem in Hurd?

One question which is going to be interesting from my perspective is
that of GPLv2 licensing.  There is definitely still code in the ext2
filesystem translator which is GPLv2 only, since it is derived from
Linux.  And as we all know, GPLv2 and GPLv3 code are licensing
incompatible, and that the FSF has claimed that the GPL will infect
across a wide variety of linking mechanisms, up to and including dynamic
linking.  Indeed, in the case of GCC, RMS has made the claim (when
pursuading NeXT to release the Objective C front-end under the GPL),
that the GPL infects across a Unix pipe!  The reason why I ask this
question is it seems extremely important whether or not the FSF has made
a determination if the GPL infects across HURD IPC calls.  If the GPLv2
does in fact infect across Hurd calls, and the Hurd is going GPLv3, it
seems that will be a need to either drop the ext2 filesystem, or rewrite
those portions of the ext2 filesystem which are derived from Linux code.

If the Hurd project is planning on dropping the ext2 filesystem, please
let me and the ext4 developers know, since then we can clean up the
special case code in e2fsprogs to support the Hurd.  

Thanks, regards,

						- Ted
