From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: >16TB issues
Date: Thu, 16 Jul 2009 14:59:13 -0400
Message-ID: <20090716185913.GO27582@shell>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com> <20090703143729.GJ20343@webber.adilger.int> <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029AbZGPS7Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 14:59:16 -0400
Content-Disposition: inline
In-Reply-To: <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 16, 2009 at 11:04:41AM -0700, Justin Maggard wrote:
> On Fri, Jul 3, 2009 at 7:38 AM, Andreas Dilger<adilger@sun.com> wrote:
> >> - ?Immediately running e2fsck on the volume before ever mounting it
> >> will not complete, and results in the following:
> >> # e2fsck -n /dev/md2
> >> e2fsck 1.41.7 (29-June-2009)
> >> Error reading block 2435874816 (Attempt to read block from filesystem
> >> resulted in short read). ?Ignore error? no
> >> /dev/md2: Attempt to read block from filesystem resulted in short read
> >> while reading block 2435874816
> >> /dev/md2: Attempt to read block from filesystem resulted in short read
> >> reading journal superblock
> >> e2fsck: Attempt to read block from filesystem resulted in short read
> >> while checking ext3 journal for /dev/md2
> >
> > It looks like there may be some problem with the underlying device?
> > I posted a program here a few months ago called "ll_ver_dev" which
> > can quickly (or slowly) verify that writes and reads to different
> > offsets in a block device return consistent data. ?The quick version
> > will detect such problems as 32-bit overflows, but if you are having
> > strange problems you might need to run the full version.
> >
> > You could also try running with a filesystem just under 16TB and
> > verifying that works.
> >
> 
> Running with a filesystem just under 16TB works fine.  Forgive my
> ignorance, but for the life of me I couldn't find an reference
> anywhere about your "ll_ver_dev" program.  But doing dd if=/dev/zero
> across the entire ~18TB didn't report any errors, so I believe the
> underlying device is in good shape.

Excellent point.  You can get the programs from here:

http://valhenson.livejournal.com/38933.html

Please do run llverdev if you have the chance - at this point, we are
stuck trying to figure out how to reproduce this bug.

We really appreciate your testing!  This definitely needs to get fixed.

-VAL
