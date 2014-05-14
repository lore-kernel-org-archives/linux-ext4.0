From: tytso@mit.edu
Subject: Re: Separate mailing list for xfstests
Date: Wed, 14 May 2014 16:04:47 +0000
Message-ID: <20140514160447.GA3974@thunk.org>
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
 <53738316.20601@redhat.com>
 <53738597.70305@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	dchinner@redhat.com, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <clm@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39649 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaENQEx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2014 12:04:53 -0400
Content-Disposition: inline
In-Reply-To: <53738597.70305@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 14, 2014 at 11:02:47AM -0400, Chris Mason wrote:
> >> linux-fsdevel might seem as a good candidate for it, but still I
> >> think that it deserves a separate ML to point people to.

I'm personally in favor of using linux-fsdevel since it might
encourage more fs developers who aren't using xfstests yet to start
using it.

For example, we started investigating using xfstests to test unionfs,
and pretty quickly found problems.  (I suspect the same problem exists
in AUFS, BTW, but I've been focusing on unionfs because it's simpler
and less scary.)  The patches to enable the use of xfstests to test
unionfs are still pretty rough, but hopefully we'll get those sent to
Dave once they are cleaned up a bit.

					- Ted
