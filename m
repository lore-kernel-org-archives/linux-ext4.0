From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: create com_err.h symlink in includedir
Date: Sun, 20 Feb 2011 18:10:15 -0500
Message-ID: <20110220231015.GA4001@thunk.org>
References: <4D5C1103.8060403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, mitchb@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59428 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1BTXKT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 18:10:19 -0500
Content-Disposition: inline
In-Reply-To: <4D5C1103.8060403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 16, 2011 at 12:01:39PM -0600, Eric Sandeen wrote:
> After debian bug #192277, debian/rules started making a symlink
> to com_err.h in /usr/include.  Now I have Fedora bug #550889
> for the same issue, and perhaps it's time to make this symlink
> by default, rather than fixing it up in packaging steps?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Pulled into the e2fsprogs tree, with the following change:

    [ Changed by tytso to remove the explicit -s option; this will
      default to creating a hard link by default, which slightly faster.
      If people want to use symlinks for all links during the install
      process, they can use configure option --enable-symlink-install.
      The reason for this change is that some file systems, like AFS,
      don't support symlinks, and AFS users complain when they can't build
      or install into AFS.  So I don't want to use symlinks
      unconditionally without a way of switching things back and forth,
      and it's easier if we just make all links made during the install
      process to be hard links or sym links. ]


      	      	    	       	      	     - Ted
