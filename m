From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Reserve xattr index for Rich ACL support
Date: Wed, 17 Apr 2013 18:14:30 -0400
Message-ID: <20130417221430.GB5401@thunk.org>
References: <1360155211-7146-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jeffm@suse.de
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42381 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558Ab3DQWPb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Apr 2013 18:15:31 -0400
Content-Disposition: inline
In-Reply-To: <1360155211-7146-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 06, 2013 at 01:53:31PM +0100, Jan Kara wrote:
> SUSE is carrying out of tree patches for Rich ACL support for ext4 as
> they didn't get upstream due to opposition of some VFS maintainers.
> Reserve xattr index for Rich ACLs so that it cannot be taken by anything
> else which would force users to backup and reset their Rich ACLs on
> files.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I've added this to the ext4 patch queue.  Thanks for poking me about
this.

Cheers,

						- Ted
