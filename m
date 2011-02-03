From: Jan Kara <jack@suse.cz>
Subject: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 3 Feb 2011 15:40:11 +0100
Message-ID: <20110203144011.GA28409@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: lsf-pc@lists.linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1BCOkN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 09:40:13 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I'm not completely sure this is interesting for enough people but maybe
it is...

As you well know, there are three independent code bases in kernel
implementing ext-based filesystems - ext2, ext3, and ext4. Of course it
costs some effort to maintain them all in a reasonably good condition so
once in a while someone comes and proposes we should drop one of ext2, ext3
or both. So I'd like to gather input what people think about this - should
we ever drop ext2 / ext3 codebases? If yes, under what condition do we deem
it is OK to drop it?

To give some facts:
Feature-wise, ext4 should now be almost a superset of both ext2 and
ext3. ext4 has nojournal mode to simulate ext2, looking at the code I only
don't see XIP support in ext4, arguably also nobh-mode but I personally
feel that these days the complication in the code isn't worth it. As far as
I know it should be backward compatible to writeably mount ext2/ext3
filesystem with ext4 (i.e., no incompatible features should be turned on
magically).

On the other hand there are differences noticeable under some conditions -
e.g. delayed allocation, data=ordered mode of ext3 gives better data
integrity than that of ext4 in practice (it's just a side effect we never
promised but app developers somehow got used to it ;), different allocation
decisions, and I believe there are more of these subtle differences.

Then of course there is the factor of the codebase itself: Ext2 - ~9k
lines, Ext3+JBD - 24k lines, Ext4+JBD2 - 43k lines. Ext2 codebase is so
simple that it sometimes serves as a "model filesystem". But arguably it
also bitrots slowly so copy-and-pasting from ext2 need not be clever idea
anymore.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
