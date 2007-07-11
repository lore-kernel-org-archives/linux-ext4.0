From: Theodore Tso <tytso@mit.edu>
Subject: Re: [EXT4 set 4][PATCH 5/5] i_version: noversion mount option to disable inode version updates
Date: Wed, 11 Jul 2007 11:48:38 -0400
Message-ID: <20070711154838.GB19456@thunk.org>
References: <1183275474.4010.132.camel@localhost.localdomain> <20070710163144.21b739f9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40047 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761287AbXGKPss (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 11:48:48 -0400
Content-Disposition: inline
In-Reply-To: <20070710163144.21b739f9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 04:31:44PM -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:37:53 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Add a "noversion" mount option to disable inode version updates.
> 
> Why is this option being offered to our users?  To reduce disk traffic,
> like noatime?
> 
> If so, what are the implications of this?  What would the user lose?

This has been removed in the latest patch set; it's needed only for
Lustre, because they set the version field themselves.  Lustre needs
the inode version to be globally monotonically increasing, so it can
order updates between two different files, so it does this itself.
NFSv4 only uses i_version to detect changes, and so there's no need to
use a global atomic counter for i_version.  So the thinking was that
there was no point doing the global atomic counter if it was not necessary.

Since "noversion" is Lustre specific, we've dropped that from the list
of patches that we'll push, and so the inode version will only have
local per-inode significance, and not have any global ordering
properties.  

We have not actually benchmarked whether or not doing the global
ordering actually *matters* in terms of being actually noticeable.  If
it isn't noticeable, I wouldn't mind changing things so that we always
make i_version globally significant (without a mount option), and make
life a bit easier for the Lustre folks.  Or if someone other
distributed filesystem requests a globally significant i_version.  But
we can cross that bridge when we get to it....

						- Ted
