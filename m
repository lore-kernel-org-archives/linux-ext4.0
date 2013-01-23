From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] contrib: add safe_getenv() support to spd_readdir
Date: Wed, 23 Jan 2013 11:22:25 -0500
Message-ID: <20130123162225.GA12058@thunk.org>
References: <1358813390-26466-1-git-send-email-tytso@mit.edu>
 <87d2ww8562.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Florian Weimer <fw@deneb.enyo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45047 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab3AWQWe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 11:22:34 -0500
Content-Disposition: inline
In-Reply-To: <87d2ww8562.fsf@mid.deneb.enyo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2013 at 01:17:25PM +0100, Florian Weimer wrote:
> 
> glibc 2.17 has secure_getenv, but not __secure_getenv.  Unfortuantely,
> this was the only way to turn this into an official interface.

Thanks for pointing this out.  I'm using Debian testing which is still
using glibc 2.13.  The bigger issue is that it's not just
spd_readdir.c (which is in contrib and so it's not compiled from the
makefile), but we are using __secure_getenv() in libext2fs and other
libraries in e2fprogs.

Use of __secure_getenv() is protected with a configure.in test, so we
won't break when we compile under glibc 2.17, but we won't have the
full benefit of using secure_getenv(), either.  We use a similar
safe_getenv() code which will skip the getenv if the process is
running setuid, or PR_GET_DUMPABLE returns 0, so hopefully that
prevents us against the worst of the security exposure, but as [1]
states, "such emulation is necessarily brittle".

[1] http://sourceware.org/glibc/wiki/Tips_and_Tricks/secure_getenv

Can someone send me a patch, please?   Or I'll put it on my todo list....

    	    	      	     	       	       - Ted

