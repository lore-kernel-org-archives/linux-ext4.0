From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Tue, 25 Aug 2009 17:11:32 -0400
Message-ID: <20090825211132.GV17684@mit.edu>
References: <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com> <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int> <20090825001554.GN17684@mit.edu> <20090825175247.GX5931@webber.adilger.int> <4A94287C.9060509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52662 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbZHYVLn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 17:11:43 -0400
Content-Disposition: inline
In-Reply-To: <4A94287C.9060509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 25, 2009 at 02:07:56PM -0400, Ric Wheeler wrote:
>> In our performance testing of barriers (not with Chris' program), it
>> was FAR better to disable the disk cache and wait for IO completion
>> (i.e. barriers disabled) on just the journal blocks than to enable the
>> cache and cause a cache flush for each "barrier".  The problem is that at
>> high IO rates there is much more data in the cache vs. the actual journal
>> blocks, and forcing the whole cache to be flushed each transaction commit
>> hurt our performance noticably.
>>
> This entirely depends on the nature of the storage device. If you are 
> running on any normal S-ATA drive, I have seen running with write cache 
> disabled can cut your large file write speed by half over running with 
> barriers enabled. Certainly less true when running with SAS or fibre 
> channel devices.

It also depends on workload, of course.

With the patch which I've posted, we can leave it up to the system
administrator.  If they want to disable the write cache, and then use
the barriers=0 mount option, that can be their choice.  However, given
that most hard drives ship with write cache enabled, so they can have
competitive Winbench scores, I think we need to have async-commit
respect the barrier option, and as with the current !async-commit
case, we should default barriers to be enabled, given that there are
known cases (such as Chris Mason's torture test) which would lead to
filesystem corruption otherwise.

Ric's test which shows that some cases barrier=1 is faster than
barrier=0 with write caching disabled is I think another argument for
keeping the defaults in the current configuration.  If people want to
experiment with disabling write cache and using barrier=0, they can
choose to do that, with or without async_commit.

The problem is without my patch, the barrier=1 mount option is
completely ignored, and there's no way to enable barriers with
async_commit --- which is clearly wrong.  So with my patch, it now
becomes safe for people to experiment with async_commit --- and if
they also to experiment with the barrier=0 w/ "hdparm -W 0" they can
do so.  For any given workload and hardware combination, there is
therefore three safe configuarions that people can try benchmarking:

     !async_commit,barrier=1,"hdparm -W 1"	(currently the default)
     async_commit,barrier=1,"hdparm -W 1"
     async_commit,barrier=0,"hdparm -W 0"

(n.b., !async_commit,barrier=0,"hdparm -W 0" is not completely safe,
since without the barrier, it's possible, although granted not very
likely, for the block layer elevator algorithm to reorder blocks in
block device queue.)

If someone would like to try appling my patch and then trying to
benchmark their favorite benchmark on the above three combinations,
I'd love to see the results.

						- Ted
