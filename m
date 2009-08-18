From: Andreas Dilger <adilger@sun.com>
Subject: Re: fsck infinite loop on corrupt ext4 file system
Date: Tue, 18 Aug 2009 13:03:01 -0600
Message-ID: <20090818190301.GL5931@webber.adilger.int>
References: <1250294105.6221.24.camel@bobble.smo.corp.google.com>
 <1250557822.23227.9.camel@bobble.smo.corp.google.com>
 <20090818160155.GC28560@mit.edu>
 <1250613069.10195.12.camel@bobble.smo.corp.google.com>
 <20090818170331.GE28560@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Frank Mayhar <fmayhar@google.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40801 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZHRTDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 15:03:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7IJ35Cm008857
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 12:03:06 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KOL0010066IUL00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 18 Aug 2009 12:03:05 -0700 (PDT)
In-reply-to: <20090818170331.GE28560@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 18, 2009  13:03 -0400, Theodore Ts'o wrote:
> Something we *could* do to further reduce the chances would be to
> compare the primary and backup group descriptors, either at
> mount-time, or in e2fsck.  This would add an extra level of paranoia,
> although the people who are trying to do 5 second boots with HDD's
> would probably complain about the extra seeks that we'd be introducing
> as a result.

I've thought about this recently as well.  Since the GDT blocks are
allocated contiguously (at least until we get META_BG filesystems) it
would only be a single extra seek and read at mount time.  For a 16TB
filesystem there are 8MB of GDT blocks, so that isn't a huge amount of
extra IO as log as we do it with a single read instead of many seeks.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

