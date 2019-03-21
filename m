Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DEAC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 15:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86BE7218D4
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 15:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfCUPFZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:05:25 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59407 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbfCUPFZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 11:05:25 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LF5KZi020804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 11:05:21 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 37115420AA8; Thu, 21 Mar 2019 11:05:20 -0400 (EDT)
Date:   Thu, 21 Mar 2019 11:05:20 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Mikhail Morfikov <mmorfikov@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: Question about ext4 extents and file fragmentation
Message-ID: <20190321150520.GE9434@mit.edu>
References: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
 <20190321031833.GB32021@mit.edu>
 <a1dba5a8-ecdd-4618-0dc2-7cf4a67b0d40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1dba5a8-ecdd-4618-0dc2-7cf4a67b0d40@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 10:29:23AM +0100, Mikhail Morfikov wrote:
> 
> Yes, I know that many things can happen during the 128M read. But wecan assume that we have some simplified environment, where we have 
> only one disk, one file we want to read at the moment, and we have 
> time to do it without any external interferences.
> 
> If I understood correctly, as long as the extents reside on a contiguous 
> region, they will be read sequentially without any delays, right? So if 
> the file in question was one big contiguous region, would it be read 
> sequentially from the beginning of the file to its end?

It *could* be read sequentially from the beginning of the file to the
end.  There are many things that might cause that not to happen, that
have nothing to do with how we store the logical to physicla map.  For
example, some other process might be requested disk reads that might
be interleaved with the reads for that file.  If you try to read too
quickly, and the system stalls due to lack of space in the page cache,
that might force some writeback that will interrupt the contiguous
read.  The possibilities are endless.

I hesitate to make a categorical statement, because I don't understand
why you are being monomaniacal about this.

> Also I have a question concerning the following sentence[1]: 
>   "When there are more than four extents to a file, the rest of the 
>   extents are indexed in a tree." 
> Does this mean that only four extents can be read sequentially in a 
> file that have only contiguous blocks of data, or because of the 
> extent cache, the whole file can be read sequentially anyway?

If you really care about this, it's possible to use the ioctl
EXT4_IOC_PRECACHE_EXTENTS which will read the extent tree and cache it
in the extent status cache.  The main use for this has been people who
want to make a really big file --- for example, it's possible to
create a single 10 TB file which is contiguous, and while the on-disk
extent tree might require a number of 4k blocks, it can be cached in a
single 12 byte extent status cache entry.

The primary use case for this ioctl is for a *random* read workload if
there is a requirement for tail latencies.  For certain workloads,
such as a distributed query of hundreds of disks to satisfy a single
search query, if a single read is slow, it will slow down the ability
to satisfy the entire search query.  To avoid that, people will worry
about the 99th or even 99.9th percentile random read latency.  And so
precaching the extent tree makes sense:

   3. Fast is better than slow.
   We know your time is valuable, so when you’re seeking an answer on
   the web you want it right away–and we aim to please. We may be the
   only people in the world who can say our goal is to have people
   leave our website as quickly as possible. By shaving excess bits
   and bytes from our pages and increasing the efficiency of our
   serving environment, we’ve broken our own speed records many times
   over, so that the average response time on a search result is a
    fraction of a second....
   	          - https://www.google.com/about/philosophy.html

But for a sequential read workload --- it really makes no sense to be
worried about this.  For example, if you are doing a streaming video
read, the need to seek to to read from the extent status tree is not
going to be noticed at all.  A HD video stream is roughly 100MB /
minute.  So once the system realizes that you are doing a sequential
read, read-ahead will automatically start pulling in new blocks ahead
of the video stream, and the need to seek to read the extent status
tree will be invisible.  And if you are copying the file, the
percentage increase for periodically seeking to read in the extent
status tree is going to be so small it might not even be measurable.

Which is why I'm really puzzled why you care.

						- Ted

