From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext4: Semantics of delalloc,data=ordered
Date: Mon, 16 Jun 2008 12:55:24 -0600
Message-ID: <20080616185524.GR3726@webber.adilger.int>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080616150533.GB3279@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60127 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYFPSza (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 14:55:30 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5GItQ6i021346
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 11:55:27 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2K00L01KGWG900@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 16 Jun 2008 11:55:26 -0700 (PDT)
In-reply-to: <20080616150533.GB3279@atrey.karlin.mff.cuni.cz>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 16, 2008  17:05 +0200, Jan Kara wrote:
>   First, I'd like to see some short comment on what semantics
> delalloc,data=ordered is going to have. At least I can imagine at least
> two sensible approaches:
>   1) All we guarantee is that user is not going to see uninitialized data.
> We send writes to disk (and allocate blocks) whenever it fits our needs
> (usually when pdflush finds them).
>   2) We guarantee that when transaction commits, your data is on disk -
> i.e., we allocate actual blocks on transaction commit.
> 
>   Both these possibilities have their pros and cons. Most importantly,
> 1) gives better disk layout while 2) gives higher consistency
> guarantees. Note that with 1), it can under some circumstances happen,
> that after a crash you see block 1 and 3 of your 3-block-write on disk,
> while block 2 is still a hole. 1) is easy to implement (you mostly did
> it below), 2) is harder. I think there should be broader consensus on
> what the semantics should be (changed subject to catch more attention ;).

IMHO, the semantic should be (1) and not (2).  Applications don't understand
"when the transaction commits" so it doesn't provide any useful guarantee
to userspace, and if they actually need the data on disk (e.g. MTA) then
they need to call fsync to ensure this.

While I agree it is theoretically possible to have the "hole in data
where there shouldn't be one" scenario, in real life these blocks would be
allocated together by delalloc+mballoc and this situation should not happen.

As for "sync with heavy IO causing slowness" problem of Firefox, I think
that delalloc will help this noticably, but I agree we can still get into
cases where a lot of dirty data was just allocated and now needs to be
flushed to disk to commit the transaction.

In the short term I don't think this can be completely fixed, but in the
long term I think it can be fixed by having mballoc do "reservations" of
space on disk, in which the dirty pages can be written.  Only after the
data is on disk does the "reservation" turn into an "allocation" in the
journal (i.e. filesystem buffers added to transaction and modified).
At that point a sync operation only has to write out the journal blocks,
because all of the data is on disk already.

I don't think it is a huge difference from what we have today, but I
also don't think it should be in the first implementation.  We would
need to split up handling of the in-memory block bitmaps so that only
the in-memory ones are updated first, then the on-disk bitmaps are
later marked in use in a transaction after the data blocks are on disk.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

