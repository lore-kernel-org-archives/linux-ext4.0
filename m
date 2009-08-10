From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC -V2 1/4] ext4: Add configurable run-time mballoc
	debugging
Date: Mon, 10 Aug 2009 16:23:24 -0400
Message-ID: <20090810202324.GE1756@mit.edu>
References: <1249874635-24250-1-git-send-email-tytso@mit.edu> <1249874635-24250-2-git-send-email-tytso@mit.edu> <4A7F9719.1030209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44486 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZHJUXZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Aug 2009 16:23:25 -0400
Content-Disposition: inline
In-Reply-To: <4A7F9719.1030209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 09, 2009 at 10:42:17PM -0500, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > Allow mballoc debugging to be enabled at run-time instead of just at
> > compile time.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/Kconfig   |    9 ++++++
> >  fs/ext4/mballoc.c |   81 ++++++++++++++++++++++++++++++++++++++--------------
> >  fs/ext4/mballoc.h |   16 ++++++++--
> >  3 files changed, 80 insertions(+), 26 deletions(-)
> 
> This looks fine to me, though is there any reason to add the debug
> verbosity level at this point, when it's all just "1?"

What I'm thinking about doing is to use a bitmask instead of a
verbosity level.  That way it will be possible to selectively enable
some debugging print messages and not others.

In the long run the right answer is to use ftrace instead, but this is
faster and more convenient when doing surgery/development on the
mballoc code.

						- Ted
