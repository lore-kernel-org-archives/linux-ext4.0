From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] print "mostly-printable" xattr strings in
	debugfs
Date: Mon, 18 Feb 2008 22:16:32 -0500
Message-ID: <20080219031632.GS25098@mit.edu>
References: <479FEF66.6040308@redhat.com> <47B9B3D9.4020706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35830 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753646AbYBSDQk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 22:16:40 -0500
Content-Disposition: inline
In-Reply-To: <47B9B3D9.4020706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 10:35:37AM -0600, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Taking a cue from getfattr... if a string is "mostly"
> > printable characters, go ahead & print as a string,
> > and escape what's left over.
> 
> Ted, ping on this?  Since we use selinux a lot, it'd be nice to have
> something readable in debugfs output.

Thanks for reminding me.  It's been applied into the maint branch.

       	   	     	       	    	    - Ted
