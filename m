From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/5] fix ext2fs_extent_insert when at last extent in
	node
Date: Thu, 17 Apr 2008 17:06:49 -0400
Message-ID: <20080417210649.GK3063@mit.edu>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com> <1207623660-1088-4-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35759 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754171AbYDQWQJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2008 18:16:09 -0400
Content-Disposition: inline
In-Reply-To: <1207623660-1088-4-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2008 at 10:00:58PM -0500, Eric Sandeen wrote:
> ext2fs_extent_insert() only did a memmove if path->left
> was > 0, but if we are at the last extent in the node,
> path->left == 0, and this node must be moved before the
> current extent is replaced with the newly inserted node.

Thanks, applied.

					- Ted
