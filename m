From: Theodore Ts'o <tytso@mit.edu>
Subject: Eric Whitney's ext4 scaling data
Date: Tue, 26 Mar 2013 00:00:48 -0400
Message-ID: <nsxhajyzu6n.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55885 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3CZEAu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 00:00:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Eric Whitney has very thoughtfully provided an updated set of ext4
scalability data (with comparisons against ext3, xfs, and btrfs)
comparing performance between 3.1 and 3.2, and comparing performance
between 3.2 and 3.6-rc3.

I've made his compressed tar file available at:

https://www.kernel.org/pub/linux/kernel/people/tytso/ext4_scaling_data.tar.xz
https://www.kernel.org/pub/linux/kernel/people/tytso/ext4_scaling_data.tar.gz

His comments on this data are:

   It contains two sets of data - one comparing 3.2 and 3.1 (this was
   the last data set I posted publicly) and another comparing 3.6-rc3
   and 3.2.  3.6-rc3 was the last data set I collected, and until now, I
   hadn't prepared graphs for it.  The graphical results are consistent
   with what I'd reported verbally over the first 2/3 of last year - not
   much change between 3.2 and 3.6-rc3.  The last large change I could
   see occurred in 3.2, as mentioned in the notes.

   The tarball unpacks into a directory named ext4_scaling_data and
   contains a few subdirectories.  The directories named 3.2 and 3.6-rc3
   map to the data sets described above.  Each contains a file named
   index.html which you can open with a web browser to see the graphs,
   browse the raw data, ffsb profiles and lockstats, etc.

   Hopefully you'll find the lockstats and other information useful,
   even though stale (3.6-rc3 became available the last week in August
   2012).

Thanks, Eric for making this data available!

                                                - Ted

P.S.  The btrfs numbers were shockingly bad, even for the random write
workload, which was unexpected for me.  I wonder if checksumming was
enabled by default, or some such, and this was hampering their
performance...
