From: Andreas Dilger <adilger@sun.com>
Subject: Re: Performance of ext4
Date: Mon, 23 Jun 2008 14:55:01 -0600
Message-ID: <20080623205501.GW6239@webber.adilger.int>
References: <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz>
 <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com>
 <20080619174211.GB9119@mit.edu>
 <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de>
 <20080620085922.GH9119@mit.edu>
 <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59089 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYFWUzM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 16:55:12 -0400
In-reply-to: <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 20, 2008  09:21 +0000, Holger Kiehl wrote:
> When the benchmark runs it writes to stdout and with tee to the result
> file. It first writes some information about the system, prepares the
> test files (creates lots of small files), calls sync and then starts
> the test. Then every minute one line gets written to the result file.
> Often I have seen that everything after the sync was missing. But
> sometimes it happened that some parts at the end are missing. But it
> was always a clean cut, that is there where no lines that where cut
> partially. The lines where always complete.

Could you enhance your test to record the file size from "stat -c %s {file}"
at the end of the test, and also "dumpe2fs -c -R 'stat <inum>' {dev}"
where <inum> is from "stat -c %i {file}".  If these two don't match after
60s, or after a "sync; sync" then there will likely be a data loss.

With delalloc it is expected that the "debugfs" output will not match up
to 30s+ after the last modification, because the write is only in memory.
With ext3 this window would be much smaller, and in fact not visible from
userspace because "debugfs" would be accessing the same (in memory) buffer
as the kernel, so it can't even access the stale data on disk.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

