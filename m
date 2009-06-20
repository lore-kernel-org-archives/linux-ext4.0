From: "Eric Sandeen" <sandeen@sandeen.net>
Subject: Re: [PATCH 3/3] xfstests: fallocate + read/write tests,
      ext4 regression tests
Date: Sat, 20 Jun 2009 16:00:27 -0500 (CDT)
Message-ID: <58093.76.66.127.206.1245531627.squirrel@www.sandeen.net>
References: <4A370DD2.6080204@sandeen.net>
    <20090620175953.GC3984@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Eric Sandeen" <sandeen@sandeen.net>, "xfs-oss" <xfs@oss.sgi.com>,
	"ext4 development" <linux-ext4@vger.kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:28851 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZFTVAZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jun 2009 17:00:25 -0400
In-Reply-To: <20090620175953.GC3984@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Jun 15, 2009 at 10:13:22PM -0500, Eric Sandeen wrote:
>> New test to test basic mixed fallocate + read & write,
>> includes a couple regression tests for bugs that ext4
>> hit.  Uses xfs_io to generate fallocate calls, so requires
>> git xfsprogs and very recent glibc at this point.
>
> Looks good to me, and again does the correct notrun for my 32-bit
> VM.  Guess I need to do the raw syscall wireup i xfsprogs eventually..

I don't mind doing it either ... how many arches? :)

-Eric

> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
>

