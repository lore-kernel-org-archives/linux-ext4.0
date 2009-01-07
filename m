From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 without a journal: some benchmark results
Date: Wed, 7 Jan 2009 15:47:39 -0500
Message-ID: <20090107204739.GC4698@mit.edu>
References: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47655 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZAGUrl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 15:47:41 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 07, 2009 at 11:29:11AM -0800, Curt Wohlgemuth wrote:
> 
> I ran both iozone and compilebench on the following filesystems, using a
> 2.6.26-based kernel, with most ext4 patches applied.  This is on a x86 based
> 4-core system, with a separate disk for these runs.

Curt, thanks for doing these test runs.  One interesting thing to note
is that even though ext3 was running with barriers disabled, and ext4
was running with barriers enabled, ext4 still showed consistently
better resuls.  (Or was this on an LVM/dm setup where barriers were
getting disabled?)

I took the liberty of reformatting the results so I could look at them
more easily:
   
                                     Iozone, 1 Thread
Average throughput     ext2           ext3            ext4       ext4-nojournal
      Type        Mean    Stddev  Mean   Stddev  Mean    Stddev  Mean    Stddev
 initl_writers: 56.6 MB/s (0.2) 56.3 MB/s (0.2) 65.5 MB/s (0.1) 66.3 MB/s (0.2)
     rewriters: 58.4 MB/s (0.2) 58.2 MB/s (0.1) 65.7 MB/s (0.2) 66.6 MB/s (0.1)
       readers: 66.3 MB/s (0.2) 66.4 MB/s (0.1) 65.8 MB/s (0.2) 66.4 MB/s (0.0)
    re-readers: 66.5 MB/s (0.0) 66.1 MB/s (0.2) 65.6 MB/s (0.3) 66.4 MB/s (0.0)
random_readers: 22.4 MB/s (0.1) 22.1 MB/s (0.1) 21.9 MB/s (0.0) 22.4 MB/s (0.1)
random_writers: 18.8 MB/s (0.0) 18.6 MB/s (0.1) 19.1 MB/s (0.1) 19.4 MB/s (0.2)

                                    Iozone, 8 Threads
Average throughput    ext2           ext3             ext4       ext4-nojournal
      Type        Mean   Stddev   Mean   Stddev   Mean   Stddev   Mean   Stddev
 initl_writers: 28.5 MB/s (0.0) 28.7 MB/s (0.1) 53.7 MB/s (0.2) 56.1 MB/s (0.1)
     rewriters: 43.5 MB/s (0.1) 43.2 MB/s (0.2) 58.3 MB/s (0.1) 60.3 MB/s (0.2)
       readers: 51.5 MB/s (0.1) 51.5 MB/s (0.0) 58.8 MB/s (0.1) 61.0 MB/s (0.0)
    re-readers: 51.8 MB/s (0.2) 51.5 MB/s (0.0) 59.0 MB/s (0.1) 61.0 MB/s (0.0)
random_readers: 20.3 MB/s (0.0) 20.2 MB/s (0.0) 20.2 MB/s (0.0) 20.4 MB/s (0.1)
random_writers: 17.3 MB/s (0.0) 17.3 MB/s (0.0) 18.1 MB/s (0.0) 18.3 MB/s (0.1)

                                     Compilebench
Average values    ext2            ext3              ext4        ext4-nojournal
   Type        Mean   Stddev   Mean   Stddev   Mean    Stddev    Mean    Stddev
init_create: 57.9 MB_s (1.9) 30.6 MB_s (2.2)  59.7 MB_s (0.4)  77.1 MB_s ( 0.2)
 new_create: 13.0 MB_s (0.2) 13.5 MB_s (0.2)  20.5 MB_s (0.0)  22.0 MB_s ( 0.1)
      patch:  7.3 MB_s (0.1) 10.6 MB_s (0.1)  12.5 MB_s (0.0)  13.1 MB_s ( 0.0)
    compile: 25.6 MB_s (0.6) 18.0 MB_s (0.3)  33.9 MB_s (0.2)  36.0 MB_s ( 0.1)
      clean: 70.4 MB_s (1.3) 41.7 MB_s (1.8) 539.5 MB_s (3.6) 592.4 MB_s (39.4)
  read_tree: 22.1 MB_s (0.0) 21.5 MB_s (0.2)  17.1 MB_s (0.1)  17.8 MB_s ( 0.2)
read_compld: 33.3 MB_s (0.2) 20.4 MB_s (1.1)  21.8 MB_s (0.1)  22.1 MB_s ( 0.1)
delete_tree:  6.5 secs (0.2) 13.5 secs (0.3)   2.7 secs (0.1)   2.5 secs ( 0.0)
  stat_tree:  5.2 secs (0.0)  6.7 secs (0.4)   2.4 secs (0.0)   2.2 secs ( 0.0)
stat_compld:  5.7 secs (0.1)  9.6 secs (2.9)   2.5 secs (0.2)   2.5 secs ( 0.0)

A couple of things to note.  If you were testing Frank's patches, I
made one additional optimization to his patch, which removed the
orphaned inode handling.  This wasn't necessary if you're running
without the journal, I'm not sure if this would be measurable in your
benchmarks, since the inodes that would be getting modified were
probably going to be dirtied and require writeback anyway, but you
might get sightly better numbers with the version of the patch I
ultimately pushed to Linus.

The other thing to note is that in Compilebench's read_tree, ext2 and
ext3 are scoring better than ext4.  This is probably related to ext4's
changes in its block/inode allocation hueristics, which is something
that we probably should look at as part of tuning exercises.  The
brtfs.boxacle.net benchmarks showed something similar, which I also
would attribute to changes in ext4's allocation policies.

						- Ted
