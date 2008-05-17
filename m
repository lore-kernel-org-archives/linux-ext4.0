From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libext2fs: ext2fs_node_split
Date: Sat, 17 May 2008 18:52:43 -0400
Message-ID: <20080517225243.GC16496@mit.edu>
References: <1210875464-25552-1-git-send-email-sandeen@redhat.com> <1210875464-25552-2-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60164 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbYEQWw7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2008 18:52:59 -0400
Content-Disposition: inline
In-Reply-To: <1210875464-25552-2-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 15, 2008 at 01:17:42PM -0500, Eric Sandeen wrote:
> When called for a given handle, this function  will split the
> current node such that half of the node's entries will be moved
> to a new tree block.  The parent will then be updated to point
> to the (now smaller) original node as well as the new node.

This patch looks good.  One minor nit; if you're going to define new
functions which are intended to be exported, then they need to be
defined in the ext2fs.h header file --- otherwise, it should be
declared static, to prevent function leakage.  Should
ext2fs_node_split() be exported?  There doesn't seem to be any reason
*not* to export it, but at the same time, there doesn't seem to be a
good reason to export, either.

I'd tend to keep it static for now; what do other people think?

        	    	    	       	    	 - Ted
