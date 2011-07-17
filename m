From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 2/3] ext4 directory index: read-ahead blocks v2
Date: Sun, 17 Jul 2011 03:02:06 +0200
Message-ID: <4E22348E.5060707@fastmail.fm>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain> <20110620202854.2473133.32514.stgit@localhost.localdomain> <20110716235950.GC2717@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-ext4@vger.kernel.org, adilger@whamcloud.com, colyli@gmail.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37265 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab1GQBCJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jul 2011 21:02:09 -0400
In-Reply-To: <20110716235950.GC2717@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted, thanks for looking into it!

On 07/17/2011 01:59 AM, Ted Ts'o wrote:
> On Mon, Jun 20, 2011 at 10:28:54PM +0200, Bernd Schubert wrote:
>> From: Bernd Schubert <bernd.schubert@fastmail.fm>
>>
>> changes from v1 -> v2:
>> Limit the number of read-ahead blocks as suggested by Andreas.
>>
>> While creating files in large directories we noticed an endless number
>> of 4K reads. And those reads very much reduced file creation numbers
>> as shown by bonnie. While we would expect about 2000 creates/s, we
>> only got about 25 creates/s. Running the benchmarks for a long time
>> improved the numbers, but not above 200 creates/s.
>> It turned out those reads came from directory index block reads
>> and probably the bh cache never cached all dx blocks. Given by
>> the high number of directories we have (8192) and number of files required
>> to trigger the issue (16 million), rather probably bh cached dx blocks
>> got lost in favour of other less important blocks.
>> The patch below implements a read-ahead for *all* dx blocks of a directory
>> if a single dx block is missing in the cache. That also helps the LRU
>> to cache important dx blocks.
> 
> If you have 8192 directories, and about 16 million files, that means
> you have about 2,000 files per directory.  I'll assume that each file
> averages 8-12 characters per file, so you need 24 bytes per directory
> entry.  If we assume that each leaf block is about 2/3rds full, you
> have about 17 leaf blocks, which means we're only talking about one
> extent index block per directory.   Does that sound about right?

I don't understand it either yet why we have so many, but each directory
has about 20 to 30 index blocks.

> 
> Even if I'm underestimating the number size of your index blocks, the
> real problem you have a very inefficient system; probably something
> like 80% or more of the space in your 8192 index blocks (one per
> directory) are are empty.  Given that, it's no wonder the index blocks
> are getting pushed out of memory.  If you reduce the number of
> directories that you have, say by a factor of 4 so that you only have
> 2048 directories, you will still only have about one index block per
> directory, but it will be much fuller, and those index blocks will be
> hit 4 times more often, which probably makes them more likely that
> they stay in memory.  It also means that instead of pinning about 32
> megabytes of memory for all of your index blocks, you'll only pin
> about 8 megabytes of memory.

For a file system with 16 million files, sure, 8192 hash directories are
far too much. However, it also easily might go up to 600 million or more
files. Lets assume 70000 to 100000 files per directory as worst case.
With that many files a hash table size of 8192 is more sane, I think. Of
course, that's a clear disadvantage of hash tables - either the size is
wrong, or slow re-hashsing is required.

> 
> It also makes me wonder why your patch is helping you.  If there's
> only one index block per directory, then there's no readahead to
> accomplish.  So maybe I'm underestimating how many leaf blocks you
> have in an average directory.  But the file names would have to be
> very, very, VERY large in order to cause us to have more than a single
> index block.  
> 
> OK, so what am I missing?

All files I tested with have a fixed length of 24 characters (16 byte
UUID + hostname).



Thanks,
Bernd



PS: Btw, I have a v3 patch series, that mostly fixed the 3rd patch ("Map
blocks with a single semaphore lock") to be checkpatch.pl clean. I just
didn't want to send another revision until we have agreed on the overall
concept (didn't want to send patch-spam...).



