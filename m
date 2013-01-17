From: Radek Pazdera <rpazdera@redhat.com>
Subject: Re: [RFC] Optimizing readdir()
Date: Thu, 17 Jan 2013 16:53:12 +0100
Message-ID: <20130117155312.GA13339@laptop.brq.redhat.com>
References: <20130113152204.GB26803@laptop.redhat.com>
 <20130114045152.GF29329@thunk.org>
 <20130115072143.GA21506@laptop.redhat.com>
 <B52E6F5A-F266-433C-AE80-2E78FD6920B9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3AQP55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 10:57:57 -0500
Content-Disposition: inline
In-Reply-To: <B52E6F5A-F266-433C-AE80-2E78FD6920B9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 03:44:57PM -0700, Andreas Dilger wrote:
>Did you consider my proposal to order the inode allocations so
>that they are (partially) ordered by the directory hash?  That
>would not require any on-disk format changes at all.  The theory
>is that keeping the entries mostly sorted in the inode table is
>enough to avoid the pathological case in large directories where
>only a single entry in each block is processed per transaction.

I only found a mention in an article about the status of ext3 from
OLS [1], but I didn't understand it at that time. I found the original
thread [2] (at least I think it is the right one). I'll have a look
at it. Thanks for pointing that out!

[1] http://www.kernel.org/doc/ols/2005/ols2005v1-pages-77-104.pdf
[2] http://lwn.net/Articles/25012/

>Having an upper limit on the directory cache is OK too.  Read all
>of the entries that fit into the cache size, sort them, and return
>them to the caller.  When the caller has processed all of those
>entries, read another batch, sort it, return this list, repeat.
>
>As long as the list is piecewise ordered, I suspect it would gain
>most of the benefit of linear ordering (sequential inode table
>reads, avoiding repeated lookups of blocks).  Maybe worthwhile if
>you could test this out?

I will try that out. It shouldn't be hard to modify the spd_readdir
preload from Ted to do just this and run the tests again.

>At the same time, the smaller the system, the smaller the directory
>will typically be, so I don't think we need to go to extremes.  If
>the piecewise ordering of readdir entries gives a sufficient speedup,
>then it would be possible to efficiently process directories of 
>arbitrary size, and optimally process the most common directories
>that fit within the buffer.

You're right, huge directories are not common at small devices. It just
occured to me, because I am using Raspberry Pi at home for backups. But
this is probably not that common.

Thank you for your suggestions!

Cheers,

Radek

>
>Cheers, Andreas
>
>
>
>
>
