From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 28 Aug 2009 16:14:32 -0600
Message-ID: <20090828221432.GS4197@webber.adilger.int>
References: <1248304214.14463.17.camel@bobble.smo.corp.google.com>
 <4A67D36D.20708@redhat.com>
 <1248366422.27509.1.camel@bobble.smo.corp.google.com>
 <4A689723.7000805@redhat.com>
 <1248372301.31323.2.camel@bobble.smo.corp.google.com>
 <20090723215614.GF4231@webber.adilger.int>
 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
 <20090828194051.GM4197@webber.adilger.int>
 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51900 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZH1WO0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 18:14:26 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7SMEQjJ017702
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 15:14:26 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP300900XQ4X500@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 28 Aug 2009 15:14:26 -0700 (PDT)
In-reply-to: <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 28, 2009  14:44 -0700, Jiaying Zhang wrote:
> On Fri, Aug 28, 2009 at 12:40 PM, Andreas Dilger<adilger@sun.com> wrote:
> > This isn't really correct, however, because i_blocks also contains
> > non-data blocks (indirect/index, EA, etc) blocks, so even with small
> > files with ACLs i_blocks may always be larger than ia_size >> 9, and
> > for ext2/3 at least this will ALWAYS be true for files > 48kB in size.
> 
> I see. I guess we need to use a special flag then. Or is there any
> other suggestions? I also have another question related to this
> problem. Why those fallocated blocks are not marked as preallocated
> blocks that will then be automatically freed in ext4_release_file?

Because fallocate() means "persistent allocation on disk", not "in memory
preallocation".  The "in memory" preallocation already happens in ext4,
and it is released when the inode is cleaned up.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

