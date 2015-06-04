From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Thu, 4 Jun 2015 13:29:15 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org> <mkg2u2$ckm$1@ger.gmane.org> <20150604014452.GA5759@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "U.Mutlu" <for-gmane@mutluit.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbbFDL3X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2015 07:29:23 -0400
In-Reply-To: <20150604014452.GA5759@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Jun 2015, Theodore Ts'o wrote:

> Date: Wed, 3 Jun 2015 21:44:52 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: U.Mutlu <for-gmane@mutluit.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: generic question: user-only directory w/o root access
> 
> On Mon, Jun 01, 2015 at 12:45:22AM +0200, U.Mutlu wrote:
> > A private directory (or private mountpoint) for the user only
> > (or for an application running under that 'user'-account).
> > 
> > The rationale behind this is: there are many system programs,
> > and other programs running with root rights. The user cannot know
> > them all and so cannot trust them. This includes also admins and the root
> > user itself.
> > 
> > The idea is to have a truly private directory or a private mountpoint
> > where by default nobody else has access to it, incl. root,
> > unless the owner grants access to others.
> 
> A user can't protect herself from root.  For one thing, root can
> modify the kernel, or install a module that runs arbitrary code inside
> the kernel context.  If you can insert or run arbitrary kernel code,
> you can do *anything*.  You can extract the user's encryption key; you
> can mess with arbitrary namespaces.  Root can use ptrace to muck with
> a running process.  Etc., etc., etc.
> 
> > So, my wish is to mount an encrypted virtual HD to a mountpoint,
> > and nobody else shall have access to it, especially not root or
> > any program with root rights.
> > 
> > Does anybody know of such an open-source solution for Linux?
> 
> No, just as there is no open-source solution for a perpetual motion
> machine...
> 
> Ultimately, the user has to trust the hardware and the firmware on it,
> the kernel, root, whoever is building the kernel (i.e., if you are
> using Debian and using the Debian kernel, you have to trust the people
> who build the Debian kernel, the Debian ftpmasters and so on).
> 
>     	      	     	     	 		   - Ted

Everything Ted mentioned is true. However there are ways to prevent
application and daemons running under root privileges doing harmful
things. Using Selinux is one of the ways
(https://en.wikipedia.org/wiki/Security-Enhanced_Linux).

However note that it'll still require you to trust your hardware,
kernel, whoever has a root access and to some extent the
applications as well because since it will protect you from someone
exploiting a bug in the application it will not fully protect you
from intentionally malicious application (because again, as a root
user you *can* do anything).

-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
