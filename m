From: Theodore Tso <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Fri, 20 Feb 2009 14:30:13 -0500
Message-ID: <20090220193013.GA28530@mini-me.lan>
References: <1235115642.22702.2.camel@localhost.localdomain> <499ECF5C.7020509@redhat.com> <1235155713.22702.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51512 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZBTVvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2009 16:51:06 -0500
Content-Disposition: inline
In-Reply-To: <1235155713.22702.25.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 21, 2009 at 07:48:32AM +1300, Andreas Friedrich Berendsen wrote:
> ...I haven't noticed  before, but before that message few more lines
> where recorded, which makes sense with the BUG line. Also, running
> fsck.ext4 on that filesystem I always got a Segment fault at an specific
> point, which it is impossible to fix. I'm in a process to remove files
> from that filesystem, as soon it finish I can run fsck again and send
> the result. Meanwhile, when removing files, rm stuck at a certain inode,
> which caused the first BUG message.

Have you tried running e2fsck?  It sounds like a filesystem corruption
is triggering a BUG() message, which is obviously a bug in and of
itself.  :-)

						- Ted

