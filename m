From: Andreas Dilger <adilger@sun.com>
Subject: reserved field in struct io_manager
Date: Tue, 26 Aug 2008 05:09:24 -0600
Message-ID: <20080826110924.GJ3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52253 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYHZLJ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 07:09:27 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7QB9Qkl009568
	for <linux-ext4@vger.kernel.org>; Tue, 26 Aug 2008 04:09:26 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6700B01G861F00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 26 Aug 2008 04:09:26 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
I notice in the struct io_manager that there are reserved fields at the
end, presumably for adding new methods to this array.  Unfortunately,
the reserved field is type "int" instead of "long" and as a result there
isn't necessarily enough space to hold a function pointer on a 64-bit
system.

Have you looked at this at all?  Presumably as methods are added on 64-bit
systems, the array grows slightly larger each time because the pointers
are larger than the amount of space removed from the array.  Possibly this
is harmless, because the consumers of this struct have allocated enough
space to handle all of the used fields.

I'm not 100% sure of the usage of this struct, but I thought I'd mention
it, because I noticed that the 64-bit methods were added there recently.

I was going to submit a patch to add a "readahead" method, which we've
been using in our "e2scan" tool to improve performance, and I thought
it might also be useful for e2fsck speedups.  If someone is interested
in these I can send them to the list, but the patches won't apply to
the current Git tree because of this change.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

