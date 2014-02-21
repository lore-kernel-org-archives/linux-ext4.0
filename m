From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: small .de translation fix
Date: Fri, 21 Feb 2014 10:25:31 -0500
Message-ID: <20140221152531.GF31047@thunk.org>
References: <52C704EC.8000501@redhat.com>
 <5306D3D9.4040303@redhat.com>
 <20140221081228.GE31047@thunk.org>
 <20140221120133.GC6304@paradies.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Philipp Thomas <pth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60829 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaBUPZk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Feb 2014 10:25:40 -0500
Content-Disposition: inline
In-Reply-To: <20140221120133.GC6304@paradies.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 21, 2014 at 01:01:33PM +0100, Philipp Thomas wrote:
> > Philipp, while you're at it, could you also take a look at these two
> > Debian bugs?
> > 
> >        https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=703048
> >        https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=737800
> 
> I'll check them.

Thanks!  Let me know if you think they are valid and when they have
been fixed, so I can close them out on the Debian side once I've
grabbed the updated po file.

>  While I have your eye: I noticed the buglet:
> 
> #: misc/e2image.c:1368
> msgid "Raw and qcow2 images cannotbe installed"

Thanks, Andrease recently sent me a patch which included a fix for
this.  It will be fixed in the next release:

https://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?h=maint&id=4d46e6c737947b336fd412f43c060955b07bd319

						- Ted
