From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Sat, 5 Jul 2014 16:36:07 -0400
Message-ID: <20140705203607.GJ11103@thunk.org>
References: <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
 <20140703134338.GE2374@thunk.org>
 <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org>
 <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46973 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbaGEUgW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 16:36:22 -0400
Content-Disposition: inline
In-Reply-To: <20140704184539.GA11103@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been auditing the ext4 code looking for a potential bug in our
journalling code that might result in fs corruption after a
crash/power failure.

I did find one such instance: http://patchwork.ozlabs.org/patch/367346/

However, I'm fairly sure this is not the cause of most of the problems
folks have been complaining about.  For one thing, this bug has been
around for a long, long time (since v3.5 or so).  For another, hitting
it is incredibly rare.

It would only be noticeable if you crash immediately (within 5 seconds
or so) after allocating the first inode in a block group where both
the inode allocation bitmap and block allocation bitmap are
uninitialized (i.e, no inodes or blocks have ever been allocated from
that block group since the file system was first initialized).

So for people who are indicating that they are seeing problems much
more frequently in 3.15, but not in older kernels, it's almost
certainly something else going on.  But if you can reliably reproduce
the problem, you might want to try applying the patch.  It certainly
won't hurt, and if it does help, please let me know.  :-)

Cheers,

						- Ted
