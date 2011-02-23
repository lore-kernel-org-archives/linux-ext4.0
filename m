From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Wed, 23 Feb 2011 17:51:50 -0500
Message-ID: <20110223225150.GQ2924@thunk.org>
References: <4D5ED705.7010902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54505 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1BWWvx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 17:51:53 -0500
Content-Disposition: inline
In-Reply-To: <4D5ED705.7010902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 18, 2011 at 02:31:01PM -0600, Eric Sandeen wrote:
> There's no good reason to require the extra step of providing
> a mount option for acl or user_xattr once the feature is configured
> on; no other filesystem that I know of requires this.
> 
> Userspace patches have set these options in default mount options,
> and this patch makes them default in the kernel.  At some point
> we can start to deprecate the options, perhaps.
> 
> For now I've removed default mount option checks in show_options()
> to be explicit about what's set, since it's changing the default,
> but I'm open to alternatives if desired.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the ext4 patch queue, thanks!!

				- Ted
