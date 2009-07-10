From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on huge_file
Date: Fri, 10 Jul 2009 11:47:52 -0600
Message-ID: <20090710174752.GE12939@webber.adilger.int>
References: <6601abe90907100832q6ab886f2r7fc8e3be2a79e8e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58334 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZGJRsH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 13:48:07 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6AHm4Mw018157
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 10:48:06 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMK00F00UOR4700@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 10 Jul 2009 10:48:04 -0700 (PDT)
In-reply-to: <6601abe90907100832q6ab886f2r7fc8e3be2a79e8e5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 10, 2009  08:32 -0700, Curt Wohlgemuth wrote:
> I apologize if this is a dumb question, but I'm having trouble
> understanding the huge_file superblock flag.
> 
> I see how, if this flag is set, that the inode can have a size > 2**32
> bytes, using the i_size_lo/i_size_high fields.

Actually, it is RO_COMPAT_LARGE_FILE that indicates support for size larger
than 2^32 _bytes_.  The RO_COMPAT_HUGE_FILE indicates support for blocks
more than 2^32 512-byte _sectors_ (2TB).

> But since an ext4_extent only uses 32-bits for for its ee_block field
> to represent the logical block, how can an extent describe any block
> range of a file past the 4GiB boundary?

There are two different mechanisms used with HUGE_FILE.  It allows
storing a high word of data (2^48 sectors) and it ALSO changes the
units to be in terms of filesystem blocksize instead of 512-byte sectors.

While both of these mechanisms are not strictly necessary with the
current extent format, which only handles 2^32 filesystem blocks,
there were some good reasons to make both changes:
- having the inode i_blocks field be in 512-byte sectors was confusing
  to many coders and wasted 3 bits (for 4kB blocks) of dynamic range.
- if we ever implement a new extent format that handles more than 2^32
  filesystem blocks, or use larger filesystem blocks we don't need to
  rework this code again.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

