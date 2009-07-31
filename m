From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Fri, 31 Jul 2009 09:10:20 -0700
Message-ID: <6601abe90907310910n694c32dfob3e2a207b07333f4@mail.gmail.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
	 <20090729181007.GC14105@mit.edu>
	 <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
	 <20090730203351.GB6833@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:46062 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaQK0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Jul 2009 12:10:26 -0400
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id n6VGANUv014999
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 17:10:24 +0100
Received: from wf-out-1314.google.com (wfa28.prod.google.com [10.142.1.28])
	by zps78.corp.google.com with ESMTP id n6VGALb7005075
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 09:10:21 -0700
Received: by wf-out-1314.google.com with SMTP id 28so595060wfa.6
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 09:10:21 -0700 (PDT)
In-Reply-To: <20090730203351.GB6833@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks to all for ideas and corrections for my original patch.  I'd like to
summarize the issues that I've seen raised:

1. Using blockdev_direct_IO_own_locking() as it stands, without additional
   locking in the ext4 code, is incorrect.

2. The conversion from uninit to initialized extents should be done in an IO
   completion handler.

3. When the uninit-to-init extents are converted, the handle must be marked
   as synchronous.

   But this will make DIO writes (to fallocated space) with a journal have
   bad performance.

4. Ted mentioned some optimizations possible for extent conversion (when the
   extent block isn't part of a transaction, and no new block is required).
   Jan says that verifying that the extent block is not part of a
   transaction can be difficult.

   Also we could increase the extent size that we're willing to zero out the
   data blocks for.

5. Aneesh mentioned that we could use extent tracking a la Chris Mason's
   patch for data=guarded (I confess, I haven't looked at this yet).

6. Jan's other thought is to use a new ext4_get_blocks_direct() routine as
   the get_block callback to blockdev_direct_IO() -- so no use of
   _own_locking().  This would simply return blocks from uninit extents;
   extent conversion (including possible splitting) would then be done in
   ext4_direct_IO().

7. Ted's last comment is about the tradeoffs between getting the journal
   transaction correct vs aggressive zeroout of data blocks -- seeing if
   it's possible to bypass the journal in the case of preallocated DIO
   writes.

Looking through these, it seems to me that there are two major problems:

   a. How to correctly do extent conversion in the face of locking issues and
      races with other requests (e.g. AIO)

   b. How to efficiently do this extent conversion in the face of correct
      journal semantics.

Have I missed anything?

Jan's idea of a new get_block callback for DIO seems like the simplest
solution to (a) above.  No locking changes would seem to be needed, I think.
Does this seem reasonable?

Problem (b) is one that I would defer to others with more experience with
journals than I have.

Thanks,
Curt
