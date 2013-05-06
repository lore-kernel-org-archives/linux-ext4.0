From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: recalculate s_blockfile_groups during resize2fs
Date: Sun, 5 May 2013 23:06:37 -0400
Message-ID: <20130506030637.GA4974@thunk.org>
References: <518426F0.1000103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Lachlan McIlroy <lmcilroy@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46515 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab3EFDGm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 May 2013 23:06:42 -0400
Content-Disposition: inline
In-Reply-To: <518426F0.1000103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 03, 2013 at 04:06:56PM -0500, Eric Sandeen wrote:
> s_blockfile_groups is used to limit allocations for non-extent
> files to block groups with block numbers less than 2^32.
> However, it's not updated when the filesystem is resized online,
> so the new groups are unavailable to non-extent files until a remount.
> 
> Fix this by updating the value in ext4_update_super() at
> resize time.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I sent out a patch about two weeks ago, which has since been accepted
into Linus's tree as commit c5c72d814cf0.  It's been marked for the
for backporting into the stable trees.

Cheers,

						- Ted

commit c5c72d814cf0f650010337c73638b25e6d14d2d4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Apr 21 20:19:43 2013 -0400

    ext4: fix online resizing for ext3-compat file systems
    
    Commit fb0a387dcdc restricts block allocations for indirect-mapped
    files to block groups less than s_blockfile_groups.  However, the
    online resizing code wasn't setting s_blockfile_groups, so the newly
    added block groups were not available for non-extent mapped files.
    
    Reported-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org
