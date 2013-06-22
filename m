From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: RE: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 14:41:25 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA2363CBE7@ATLEXMBX4.ARRS.ARRISI.com>
References: <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
 <20130621203547.GA10582@thunk.org> <20130622032944.GX29376@dastard>
 <20130622044718.GC4727@thunk.org>
 <C0F0BC787567C848B2C90989451123DA2363CBBE@ATLEXMBX4.ARRS.ARRISI.com>,<20130622140613.GE4727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Dave Chinner <david@fromorbit.com>, Ryan Lortie <desrt@desrt.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.arrisi.com ([216.234.147.109]:44070 "EHLO mail.arrisi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3FVOla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jun 2013 10:41:30 -0400
In-Reply-To: <20130622140613.GE4727@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Stop right there.  If you are doing lots of appending writes, and you
> dont want to lose no more than 5 seconds, why do you have 15 files?
> Why send your appending writes into a single file and then later on,
> disaggregate out the logs when you need to read them?

There are 15 files because those are different entities. There might be less of
them, some of them can be removed. There is no reason to place those files
close to each other since those are just metadata related to mpeg stream
and in fact it is best to put stream and metadata close to each other.
If I wanted to localize those small files, I would just put them on a different
partition.

Anyway, if I have to implement a file system inside a file, why do I need
top layer file system? : )

> With 15 files,
> no matter what you are doing, you will be forcing the heads to seek
> all over the place, and since the 4k blocks won't be full when you
> sync them, you're wasting write cycles and disk bandwidth.

Yes, seeks are unavoidable, but that's something I have to account in worst
case scenario anyway.
Huh, yes. Another advantage of ext4 is that I can control writeback on a
specific file range. I sync only complete pages and ext4 is happy to commit
whatever was synced. Generic solution would be to cache pages in app and
submit only complete ones. Disadvantage of generic solution is that data
cached by app is invisible to others.

Regards,
Andrey.
