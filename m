From: Radek Pazdera <rpazdera@redhat.com>
Subject: Re: [RFC] Optimizing readdir()
Date: Tue, 29 Jan 2013 17:38:46 +0100
Message-ID: <20130129163846.GA17169@laptop.brq.redhat.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:63065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3A2QjV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 11:39:21 -0500
Content-Disposition: inline; filename="ext4m.txt"
In-Reply-To: <B52E6F5A-F266-433C-AE80-2E78FD6920B9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 03:44:57PM -0700, Andreas Dilger wrote:
>Having an upper limit on the directory cache is OK too.  Read all
>of the entries that fit into the cache size, sort them, and return
>them to the caller.  When the caller has processed all of those
>entries, read another batch, sort it, return this list, repeat.
>
>As long as the list is piecewise ordered, I suspect it would gain
>most of the benefit of linear ordering (sequential inode table
>reads, avoiding repeated lookups of blocks).  Maybe worthwhile if
>you could test this out?

I did the tests last week. I modified the spd_readdir preload to
read at most $SPD_READDIR_CACHE_LIMIT entries, sort them and repeat.
The patch is here:

    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext4/

I tested it with the limit set to 0 (i.e., no limit), 1000, 10000,
50000, and completely without the preload. The test runs were
performed on the same directory, so the results shouldn't be
affected by positioning on disk.

Directory sizes went from 10k to 1.5M. The tests were run twice.
The first run is only with metadata. In the second run, each file
has 4096B of data.

Here are the results:
  0B files:
    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext4/0B-files

  4096B files:
    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext4/4096B-files/

The times seem to decrease accordingly as the limit of the cache
increases. The differences are bigger in case of 4096B files, where
the data blocks start to evict the inode tables. However, copying is
still more than two times slower for 1.5M files when 50000 entries
are cached.

It might be interesting to test what happens when the size of the
files in the directory increases.

Best Regards
Radek
