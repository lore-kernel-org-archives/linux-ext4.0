From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic question: user-only directory w/o root access
Date: Wed, 3 Jun 2015 21:44:52 -0400
Message-ID: <20150604014452.GA5759@thunk.org>
References: <mkfbkb$fo1$1@ger.gmane.org>
 <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46604 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbbFDBoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2015 21:44:55 -0400
Content-Disposition: inline
In-Reply-To: <mkg2u2$ckm$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 01, 2015 at 12:45:22AM +0200, U.Mutlu wrote:
> A private directory (or private mountpoint) for the user only
> (or for an application running under that 'user'-account).
> 
> The rationale behind this is: there are many system programs,
> and other programs running with root rights. The user cannot know
> them all and so cannot trust them. This includes also admins and the root
> user itself.
> 
> The idea is to have a truly private directory or a private mountpoint
> where by default nobody else has access to it, incl. root,
> unless the owner grants access to others.

A user can't protect herself from root.  For one thing, root can
modify the kernel, or install a module that runs arbitrary code inside
the kernel context.  If you can insert or run arbitrary kernel code,
you can do *anything*.  You can extract the user's encryption key; you
can mess with arbitrary namespaces.  Root can use ptrace to muck with
a running process.  Etc., etc., etc.

> So, my wish is to mount an encrypted virtual HD to a mountpoint,
> and nobody else shall have access to it, especially not root or
> any program with root rights.
> 
> Does anybody know of such an open-source solution for Linux?

No, just as there is no open-source solution for a perpetual motion
machine...

Ultimately, the user has to trust the hardware and the firmware on it,
the kernel, root, whoever is building the kernel (i.e., if you are
using Debian and using the Debian kernel, you have to trust the people
who build the Debian kernel, the Debian ftpmasters and so on).

    	      	     	     	 		   - Ted
