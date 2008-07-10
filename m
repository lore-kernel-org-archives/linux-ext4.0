From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: suspiciously good fsck times?
Date: Thu, 10 Jul 2008 13:30:32 -0400
Message-ID: <48764738.5050709@redhat.com>
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198AbYGJRag (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2008 13:30:36 -0400
In-Reply-To: <20080710151822.GA25939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Jul 10, 2008 at 08:36:42AM -0400, Ric Wheeler wrote:
>   
>> Just to be mean, I have been trying to test the fsck speed of ext4 with  
>> lots of small files.  The test I ran uses fs_mark to fill a 1TB Seagate  
>> drive with 45.6 million 20k files (distributed between 256 
>> subdirectories).
>>
>> Running on ext3, "fsck -f" takes about one hour.
>>
>> Running on ext4, with uninit_bg, the same fsck is finished in a bit over  
>> 5 minutes - more than 10x faster.  (Without uninit_bg, the fsck takes  
>> about 10 minutes).
>>
>> Is this too good to be true? Below is the fsck run itself, the tree is  
>> Ted's latest git tree and his 1.41 WIP tools,
>>     
>
> Wow.  My guess is that flex_bg is making the difference.  What we
> would want to compare is the I/O read statistics line:
>
>   
>> I/O read: 14198MB, write: 1MB, rate: 46.77MB/s
>>     
>
> That's pretty good, and indicates we've avoided a *lot* of seeking.
> The e2fsck -t -t output for ext3 should show roughly the same mount of
> I/O read (with 20k files, there would be no advantage towards using
> extents), but the I/O rate is probably *much* lower, indicating a lot
> more seeking is going on.
>   
We did run fsck through seekwatcher & saw a significant reduction in
seeks/sec for ext4. Eric has the pretty pictures that he can share.

> Can you send the full e2fsck -t -t output of the ext3 run?  And what
> is the hdparm -t -t results of the disk?
>   

I didn't run the ext3 test with -t -t (but can refill and rerun, takes
about 12 hours).

This disk is a relatively new Seagate 1TB drive, specs at:

http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD

hdparm test:

[root@localhost rwheeler]# /sbin/hdparm -t -t /dev/sdb

/dev/sdb:
Timing buffered disk reads:  186 MB in  3.03 seconds =  61.33 MB/sec



> If I'm right, if you create the filesystem with mke2fs -t ext4dev -O
> ^flex_bg,^uninit_bg, you should see performance back to the old ext3
> levels.
>   

With uninit_bg off, it ran about 10 minutes, but it would be interesting
to run without either.
> 							- Ted
>
> P.S.  We probably do want to examine the block allocation layout with
> flex_bg to make sure that the filesystem ages well in the long term.
>   
Testing aged file systems is always the holy grail - this workload is a
fairly artificial one and was laid down with 4 threads currently writing
to a shared subdirectory.

ric


