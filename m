From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [RFC] Self healing extent map OR opportunistic de-fragmentation
Date: Tue, 9 Nov 2010 01:58:21 -0700
Message-ID: <25081AB5-124D-4E29-AB89-94A05F0106D1@dilger.ca>
References: <AANLkTinsZRSU46J0JXm2A=u=d-JpQfdYnk0oHf3NC9O_@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:5330 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0KII6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 03:58:23 -0500
In-Reply-To: <AANLkTinsZRSU46J0JXm2A=u=d-JpQfdYnk0oHf3NC9O_@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-08, at 21:14, Amir Goldstein wrote:
> I would like to propose a simple idea how to automatically de-fragment a file.

[snip]

> The use case for this, besides healing fragmentation caused by
> snapshots move-on-rewrite, is an highly fragmented ext2/3 fs, which was mounted as ext4.  ext2/3 old files are slowly being deleted while new (still fragmented) extent mapped files are being created.
> This viscous cycle cannot end before there is enough contiguous free
> space for writing new files, which may never happen.

This will only happen in case the free space is _very_ low.  Normally, in a situation like this, mballoc will allocate the largest contiguous chunks of free space, reducing the fragmentation as new files are written, and allocations to highly-fragmented block groups will be avoided until the chunks in those groups have grown larger.

> Online de-fragmentation will not help in this case either.
> With opportunistic de-fragmentation, if the extent mapped files are
> being re-written, the health of the file system will constantly improve over time.  BTW, Is this use case relevant for upgraded google chunk servers?

While this is true in theory, the problem is that in most cases files are not overwritten in place.  Commonly, when files are "rewritten" they are truncated and new blocks allocated, or a new file is written and renamed in place of the old file.  Only in rare cases, like databases, are files rewritten in-place.

Cheers, Andreas





