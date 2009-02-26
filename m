From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix discard of inode prealloc space with delayed
	allocation.
Date: Thu, 26 Feb 2009 00:59:19 -0500
Message-ID: <20090226055919.GA7227@mit.edu>
References: <1235578922-7790-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57517 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbZBZF7X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 00:59:23 -0500
Content-Disposition: inline
In-Reply-To: <1235578922-7790-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 09:52:02PM +0530, Aneesh Kumar K.V wrote:
> With delayed allocation we should not/cannot discard inode prealloc
> space during file close. We would still have dirty pages for which
> we haven't allocated blocks yet. With this fix after each get_blocks
> request we check whether we have zero reserved blocks and if yes and
> we don't have any writers on the file we discard inode prealloc
> space.

Thanks, applied in the ext4 patch queue.

						- Ted
