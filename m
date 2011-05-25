From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Convert ext4 to new truncate calling convention
Date: Wed, 25 May 2011 09:45:36 -0400
Message-ID: <20110525134536.GB8476@thunk.org>
References: <1306312988-5508-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46697 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938Ab1EYNpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 09:45:41 -0400
Content-Disposition: inline
In-Reply-To: <1306312988-5508-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 10:43:08AM +0200, Jan Kara wrote:
>  int ext4_can_truncate(struct inode *inode)
>  {
> -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -		return 0;

I agree this change is correct, but I noticed that at the VFS level,
the ftruncate() path doesn't seem to check for IS_APPEND() and
IS_IMMUTABLE().  Am I missing something?  Fixing that should be a
separate patch, of course, but it does seem to be a problem.

	 	   	       	       - Ted
