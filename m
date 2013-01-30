From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC] Optimizing readdir()
Date: Wed, 30 Jan 2013 12:34:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1301301227410.28271@dhcp-1-104.brq.redhat.com>
References: <20130113152204.GB26803@laptop.redhat.com> <20130114045152.GF29329@thunk.org> <20130115072143.GA21506@laptop.redhat.com> <B52E6F5A-F266-433C-AE80-2E78FD6920B9@dilger.ca> <20130129163846.GA17169@laptop.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-753106902-1359545665=:28271"
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: Radek Pazdera <rpazdera@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab3A3Le2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 06:34:28 -0500
In-Reply-To: <20130129163846.GA17169@laptop.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-753106902-1359545665=:28271
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 29 Jan 2013, Radek Pazdera wrote:

> Date: Tue, 29 Jan 2013 17:38:46 +0100
> From: Radek Pazdera <rpazdera@redhat.com>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
>     Luká¨ Czerner <lczerner@redhat.com>
> Subject: Re: [RFC] Optimizing readdir()
> 
> On Tue, Jan 15, 2013 at 03:44:57PM -0700, Andreas Dilger wrote:
> >Having an upper limit on the directory cache is OK too.  Read all
> >of the entries that fit into the cache size, sort them, and return
> >them to the caller.  When the caller has processed all of those
> >entries, read another batch, sort it, return this list, repeat.
> >
> >As long as the list is piecewise ordered, I suspect it would gain
> >most of the benefit of linear ordering (sequential inode table
> >reads, avoiding repeated lookups of blocks).  Maybe worthwhile if
> >you could test this out?
> 
> I did the tests last week. I modified the spd_readdir preload to
> read at most $SPD_READDIR_CACHE_LIMIT entries, sort them and repeat.
> The patch is here:
> 
>     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext4/
> 
> I tested it with the limit set to 0 (i.e., no limit), 1000, 10000,
> 50000, and completely without the preload. The test runs were
> performed on the same directory, so the results shouldn't be
> affected by positioning on disk.
> 
> Directory sizes went from 10k to 1.5M. The tests were run twice.
> The first run is only with metadata. In the second run, each file
> has 4096B of data.
> 
> Here are the results:
>   0B files:
>     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext4/0B-files
> 
>   4096B files:
>     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext4/4096B-files/
> 
> The times seem to decrease accordingly as the limit of the cache
> increases. The differences are bigger in case of 4096B files, where
> the data blocks start to evict the inode tables. However, copying is
> still more than two times slower for 1.5M files when 50000 entries
> are cached.
> 
> It might be interesting to test what happens when the size of the
> files in the directory increases.
> 
> Best Regards
> Radek

Hi Radek,

those are interesting results and it supports the idea that you can
get most of the performance of completely sorted inode list by doing
it in "batches" as long as the size of the batch is sufficiently
large. However I do not think that using spd_readdir is the best
approach for the problem, nor do I think that it should be part of
the generic library. Aside from it's "hackish" nature and the fact
you will never be able to tell how much memory you can actually use
for the sorting, the fact is that other file systems can handle this
problem well enough in comparison with ext4 and we should really
focus on fixing it, rather than going around it.

Thanks!
-Lukas
--571107329-753106902-1359545665=:28271--
