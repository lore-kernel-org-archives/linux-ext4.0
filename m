From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Memory leak fix ext4_group_info allocation.
Date: Fri, 17 Jul 2009 09:01:18 -0400
Message-ID: <20090717130118.GI8508@mit.edu>
References: <1247669734-6819-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59466 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934542AbZGQNBb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jul 2009 09:01:31 -0400
Content-Disposition: inline
In-Reply-To: <1247669734-6819-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 15, 2009 at 08:25:34PM +0530, Aneesh Kumar K.V wrote:
> commit 5f21b0e642d7bf6fe4434c9ba12bc9cb96b17cf7  was done to
> reallocate groupinfo struct during resize properly. That goal
> was to allocate new groupinfo struct when we are adding new block
> groups during resize. Calling ext4_mb_add_group_info in the
> mballoc initialization code path resulted in we reallocating
> the group info struct . Fix this by not separately allocating
> group info in the mballoc init path and always depend on
> ext4_mb_add_group_info to allocate group info struct.
> 
> The earlier code also had a bug that we allocated less number of
> group info struct for the last meta group. But on resize we
> expected that we had EXT4_DESC_PER_BLOCK group info struct for
> each meta group.

Added to the ext4 patch queue, although I did rewrite the patch
description:

ext4: Fix memory leak fix when mounting an ext4 filesystem

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

The allocation of the ext4_group_info array was moved to a new
function ext4_mb_add_group_info() in commit 5f21b0e6 so that online
resize would use a common (and correct) codepath.  Unfortunately, the
call to the new ext4_mb_add_group_info() function was added without
removing the code which originally allocated the array.  This caused a
memory leak each time an ext4 filesystem was mounted.

The fix is simple; remove the code that did the original allocation,
since it is no longer needed.

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

					- Ted
