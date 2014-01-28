From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: 28 Jan 2014 07:26:23 -0500
Message-ID: <20140128122623.26029.qmail@science.horizon.com>
Cc: adilger@dilger.ca, andi@firstfloor.org, linux@horizon.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: tmac@hp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The third part of the patch further increases the scalablity of an ext4
> filesystem by having each ext4 fielsystem allocate and use its own private
> mbcache structure, instead of sharing a single mcache structures across all
> ext4 filesystems, and increases the size of its mbcache hash tables.

Are you sure this helps?  The idea behind having one large mbcache is
that one large hash table will always be at least as well balanced as
multiple separate tables, if the total size is the same.

If you have two size 2^n hash tables, the chance of collision is equal to
one size  2^(n+1) table if they're equally busy, and if they're unequally
busy. the latter is better.  The busier file system will take less time
per search, and since it's searcehed more often than the less-busy one,
net win.

How does it compare with just increasing the hash table size but leaving
them combined?
