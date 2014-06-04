From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/4 v2] e2fsck: make a prompt message simpler and thus
 translatable
Date: Wed, 4 Jun 2014 12:03:21 -0400
Message-ID: <20140604160321.GC30424@thunk.org>
References: <20140602234001.GJ30598@thunk.org>
 <1401827722-13286-1-git-send-email-bensberg@justemail.net>
 <20140604020719.GC27426@thunk.org>
 <1401884601.6870.125052445.0CA47507@webmail.messagingengine.com>
 <20140604125650.GF27426@thunk.org>
 <1401888336.22807.125078021.186DE367@webmail.messagingengine.com>
 <20140604144239.GI27426@thunk.org>
 <1401896292.29436.125136989.78578825@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50279 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaFDQDZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 12:03:25 -0400
Content-Disposition: inline
In-Reply-To: <1401896292.29436.125136989.78578825@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 05:38:12PM +0200, Benno Schulenberg wrote:
> On Wed, Jun 4, 2014, at 16:42, Theodore Ts'o wrote:
> > So it looks like allowing the placement of the XXX characters in the
> > middle of the filename is a GNU coreutils extension, and it must have
> > been introduced very shortly after Ubuntu 10.04 snapshotted its
> > coreutils package from Debian.
> 
> You are right.  On Wed Nov 4 2009 there is this in coreutils' git:
> 
> -TEMPLATE must end in at least 3 consecutive `X's.\n\
> +TEMPLATE must contain at least 3 consecutive `X's in last component.\n\
> 
> and:
> 
> -count_trailing_X_s (const char *s)
> +count_consecutive_X_s (const char *s, size_t len)
> 
> So, you can probably drop the patch.

Well, I actually care about portability to *BSD and other legacy Unix
systems :-), so I plan to the change to push the XXXXXX to the end of
the template.

Thanks for pointing this out,

							- Ted

