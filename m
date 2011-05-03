From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Fix fs corruption when make_indexed_dir()
 fails
Date: Tue, 3 May 2011 11:11:41 -0400
Message-ID: <20110503151141.GC6462@thunk.org>
References: <1304112212-23417-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60893 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1ECPLo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 11:11:44 -0400
Content-Disposition: inline
In-Reply-To: <1304112212-23417-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 29, 2011 at 11:23:32PM +0200, Jan Kara wrote:
> When make_indexed_dir() fails (e.g. because of ENOSPC) after it has
> allocated block for index tree root, we did not properly mark all
> changed buffers dirty.  This lead to only some of these buffers
> being written out and thus effectively corrupting the directory.
> 
> Fix the issue by marking all changed data dirty even in the error
> failure case.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, added to the ext4 tree.

					- Ted
