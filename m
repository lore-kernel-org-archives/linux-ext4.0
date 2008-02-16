From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] UPDATED: building e2fsprogs-interim
Date: Fri, 15 Feb 2008 23:25:42 -0500
Message-ID: <20080216042542.GD26734@mit.edu>
References: <47B487C4.8010602@redhat.com> <47B5E188.6080502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38317 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbYBPGRy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2008 01:17:54 -0500
Content-Disposition: inline
In-Reply-To: <47B5E188.6080502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 15, 2008 at 01:01:28PM -0600, Eric Sandeen wrote:
> An update; running through the whole fedora build turned up another
> one (csum.o).  Out of curiosity do things like ext2_fs.h (which are not
> generated) really need to be listed as dependencies?

Well, in an RPM build you probably don't need them, no.  

But they are useful in an developer tree because if ext2_fs.h gets
modified, it's good to recompile all source files that include it ---
just to make sure any errors in the header file get caught.

     	     	      	     	    - Ted
