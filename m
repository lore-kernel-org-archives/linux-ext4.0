From: Andrew Morton <akpm@linux-foundation.org>
Subject: ext4 changes in linux-next
Date: Wed, 7 Jan 2009 14:04:36 -0800
Message-ID: <20090107140436.46a17a3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbZAGWFB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 17:05:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Ted,

a pile of new ext4 stuff just turned up in linux-next.  This means that
I had to rework
filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
a little bit, and that patch now has a dependency upon the newly-added
ext4 patches.

I assume those one-day-old changes are targetted at 2.6.20, so I'll
need to undo that fix when I send
filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
(perhaps today) and this will then cause conflicts in ext4 and/pr
linux-next.

It's not a big problem in this case, but this is why we ask that new
work not be added into linux-next until 2.6.x-rc1 has been cut.

Ta.
