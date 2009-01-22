From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: e2fsck faults with corrupted images
Date: Thu, 22 Jan 2009 12:12:01 +0100
Message-ID: <20090122111201.GA32200@alice>
References: <20090122085609.GA29546@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: pavel@suse.cz, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59922 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753983AbZAVLNP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 06:13:15 -0500
Content-Disposition: inline
In-Reply-To: <20090122085609.GA29546@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> As suggested by pavel i tested how e2fsck handles corrupted images,
> I used the fuzzer bunny (http://code.google.com/p/bunny-the-fuzzer/)
> At http://www.cccmz.de/~snakebyte/e2fsck_err.tar.bz2 you
> can find a bunch of images crashing e2fsck or keeping it in an endless
> loop. I tested with e2fsck 1.41.0 which was the one i had at hand.
> 
> The crashes are either in ext2fs_inode_alloc_stats2() or
> ext2fs_read_inode_full(), looks like those are always the same
> faults.

I just tried again with e2sck 1.41.3 and I can still
produce the errors.

Greetings, Eric
