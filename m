From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Bug#679830: linux-image-2.6.32-5-686: Kernel bug observed in
 syslog when performing an rsync operation.
Date: Sun, 22 Jul 2012 19:33:53 -0400
Message-ID: <20120722233353.GC9958@thunk.org>
References: <20120701221420.1784.81013.reportbug@altair.ejectdisc.net>
 <1342932566.11373.229.camel@deadeye.wl.decadent.org.uk>
 <CABpWkk_4=E=GMY5MhyD9ysyUSr=3F=aCqAxQ_07g5s9N8KQhjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Akinobu Mita <akinobu.mita@gmail.com>, 679830@bugs.debian.org,
	linux-ext4@vger.kernel.org
To: Imran Chaudhry <ichaudhry@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40564 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2GVXeE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2012 19:34:04 -0400
Content-Disposition: inline
In-Reply-To: <CABpWkk_4=E=GMY5MhyD9ysyUSr=3F=aCqAxQ_07g5s9N8KQhjg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 22, 2012 at 11:26:18AM +0100, Imran Chaudhry wrote:
> 
> Thanks for your reply Ben.
> 
> As an aside, from what kernel version would you recommend use of ext4 in?
> 
> Maybe I should use (tried and rusted) ext3 for my backup devices. I
> mentioned this problem in my local LUG and a couple of people reported
> similar problems with ext4.

There were a lot of important bug fixes were integrated in the oh,
2.6.35 or 2.6.36.  Unfortunately, porting the necessary ext4 patches
to 2.6.32 was very difficult, since some of the patches in question
had prerequisites that involved fairly massive changes to the quota
subsystem.

An enterprise distro such as Red Hat could make the backports work,
but it wasn't easy, and Red Hat by policy doesn't release its broken
out patches, so it's hard for Oracle (and Debian) to profit by the
yeoman work done by Eric Sandeen.  (Note, by the way, not his fault;
blame Red Hat management.)

As a result, I would strongly recommend that people use a more modern
3.x kernel.

Since Debian Wheezy will be using a 3.2-based kernel, this problem
will be addressed for the Debian stable users (hopefully!) soon.

Regards,

						- Ted
