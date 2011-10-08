From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] dumpe2fs: Warn when filesystem is mounted read-write
Date: Sat, 8 Oct 2011 13:50:01 -0400
Message-ID: <20111008175001.GE7948@thunk.org>
References: <1311866224-27351-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34132 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1JHRuH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 13:50:07 -0400
Content-Disposition: inline
In-Reply-To: <1311866224-27351-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 28, 2011 at 05:17:04PM +0200, Jan Kara wrote:
> When dumpe2fs is used on a filesystem mounted read-write, printed information
> may be old and inconsistent because e.g. updates of some superblock fields
> happen lazily or because we do not really try to handle various intermediate
> states of filesystem operations. Document this in the manpage and warn user
> when dumpe2fs is used for such filesystem.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I decided to move the warning in the man page to the DESCRIPTION
section, since it's really not a bug, but something which should be
self-evident.

And I also decided for that reasn to not have dumpe2fs print it.  If
users complain, we can now just tell them to RTFM.

      		       	   	     	  - Ted
