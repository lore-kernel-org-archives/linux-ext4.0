From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support for
 Ext4
Date: Thu, 1 Feb 2007 12:17:58 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0702011200340.9072@compserv1>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1>
 <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harry Papaxenopoulos <harry@cs.sunysb.edu>,
	linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:60908 "EHLO sbcs.cs.sunysb.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXBARVy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Feb 2007 12:21:54 -0500
In-Reply-To: <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Right now I've only really looked at the jfs patch, since that's what
> I'm the most familiar with.  I'll try to take a look at the rest of them
> later.

Thank you!

> I don't have a strong opinion for or against the function and your
> design.  The only potential problem I see in the approach is that
> the .trash directory may conflict with some other use of the same name.
> Since this is primarily vfs function, you'll probably get a wider
> audience on linux-fsdevel.

Well, I guess lost+found has the same problem but it is not a problem at
all to pick some other (longer) name.

> Have you considered putting ALL of the function in the vfs layer?  It
> looks like this could be done without touching any code in the
> individual file systems.

Unfortunately, we need some file system-specific code to access per-file
secure deletion and per-file trash bit attributes.  These attributes are
supported only by some file systems and in different ways.  We need no
file system-specific code to support trash-bin deletion for whole file
systems.

Nikolai.
