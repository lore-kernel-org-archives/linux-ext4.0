From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Random corruption test for e2fsck
Date: 11 Jul 2007 17:20:51 +0200
Message-ID: <p73myy3x8z0.fsf@bingen.suse.de>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759246AbXGKOZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 10:25:39 -0400
In-Reply-To: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah <kalpak@clusterfs.com> writes:

> regression tests. It does the following:
> 1) Create an test fs and format it with ext2/3/4 and random selection of
> features.
> 2) Mount it and copy data into it.
> 3) Move around the blocks of the filesystem randomly causing corruption.
> Also overwrite some random blocks with garbage from /dev/urandom. Create
> a copy of this corrupted filesystem.

If you use a normal pseudo random number generator and print the seed
(e.g. create from the time) initially the image can be easily recreated 
later without shipping it around. /dev/urandom
is not really needed for this since you don't need cryptographic
strength randomness. Besides urandom data is precious and it's 
a pity to use it up needlessly.

bash has $RANDOM built in for this purpose.

-Andi
