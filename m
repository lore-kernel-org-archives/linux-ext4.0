From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Mon, 25 Jun 2012 17:58:18 +0100
Message-ID: <20120625165721.GX21859@amd.home.annexia.org>
References: <4FDEC3C2.4060909@secunet.com>
 <20120625113457.GA1289@amd.home.annexia.org>
 <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab2FYQ6W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 12:58:22 -0400
Content-Disposition: inline
In-Reply-To: <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 25, 2012 at 12:38:03PM -0400, Jeff Moyer wrote:
> "Richard W.M. Jones" <rjones@redhat.com> writes:
> 
> > On Mon, Jun 18, 2012 at 07:59:30AM +0200, Torsten Hilbrich wrote:
> >> Hello,
> >> 
> >> a software that tries to mount each existing partition as ext3 file system started to fail when updating from v3.3.7 to v3.3.8.
> >> 
> >> The applications then hangs-up in the mount syscall, here is a snapshot of its stack at this moment:
> >
> > We just ran into what we think is the same problem.
> >
> > Note that ext4 fails like this for any 1024 byte sized filesystem (of
> > zeroes) that you try to mount.  It's really nothing to do with
> > extended partitions.
> >
> > Here is a very simple reproducer + stack trace:
> >
> >   https://bugzilla.redhat.com/show_bug.cgi?id=835019#c4
> >
> > I will try out the patch suggested later on in this thread.
> 
> Please try the attached patch instead.  The patch I had originally
> posted for this allowed marking the first buffer beyond EOD as
> uptodate.  This isn't correct.  The patch I've attached below fixes the
> infinite loop in __getblk_slow.

Thanks Jeff.  I'm trying it now.

We also found a related bug in isofs:

  https://bugzilla.redhat.com/show_bug.cgi?id=835084

So I will check whether your patches fixes that one too.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
