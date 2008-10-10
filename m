From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: Rename ext4dev to ext4
Date: Fri, 10 Oct 2008 15:46:56 -0400
Message-ID: <20081010194656.GF8645@mit.edu>
References: <1223356130-22006-1-git-send-email-tytso@mit.edu> <48EF9853.8070202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53466 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760060AbYJJTq6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 15:46:58 -0400
Content-Disposition: inline
In-Reply-To: <48EF9853.8070202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 01:00:51PM -0500, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > The ext4 filesystem is getting stable enough that it's time to drop
> > the "dev" prefix.  Also remove the requirement for the TEST_FILESYS
> > flag.
> 
> What do you think of adding a MODULE_ALIAS("ext4dev"); to this change?
> 
> Poor Fedora users trying to boot a kernel with this rename and ext4(dev)
> on root are failing to mount root at boot time.
> 
> mkinitrd looks at the existing fstab, sees that the rootfs is "ext4dev"
> and tries to mount root as ext4dev.... this fails.

>From discussion on the irc channel; the MODULE_ALIAS() allows the
filesystem to be loaded, but mount still tries to load the wrong
filesystem, and so it fails.

I guess one thing we *could* do is register both ext4dev and ext4....
maybe with a config option for backwards compatibility?  And try to
wean people off of it as quickly as possible.

							- Ted
