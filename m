From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 19 Aug 2011 11:05:21 +0400
Message-ID: <4E4E0B31.3000601@msgid.tls.msk.ru>
References: <4E48390E.9050102@msgid.tls.msk.ru> <4E488625.609@tao.ma> <4E48D231.5060807@msgid.tls.msk.ru> <4E48DF31.4050603@msgid.tls.msk.ru> <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com> <20110816135325.GD23416@quack.suse.cz> <4E4A86D0.2070300@tao.ma> <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com> <4E4AEF13.7070504@msgid.tls.msk.ru> <CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com> <20110817170236.GB6901@thunk.org> <4E4CB5F0.6000202@msgid.tls.msk.ru> <4E4DD613.8050700@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Jiaying Zhang <jiayingz@google.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:37821 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1HSHFY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Aug 2011 03:05:24 -0400
In-Reply-To: <4E4DD613.8050700@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 19.08.2011 07:18, Tao Ma wrote:
> Hi Michael,
> On 08/18/2011 02:49 PM, Michael Tokarev wrote:
[]
>> What about current situation, how do you think - should it be ignored
>> for now, having in mind that dioread_nolock isn't used often (but it
>> gives _serious_ difference in read speed), or, short term, fix this
>> very case which have real-life impact already, while implementing a
>> long-term solution?

> So could you please share with us how you test and your test result
> with/without dioread_nolock? A quick test with fio and intel ssd does't
> see much improvement here.

I used my home-grown quick-n-dirty microbenchmark for years to measure
i/o subsystem performance.  Here are the results from 3.0 kernel on
some Hitachi NAS (FC, on brocade adaptors), 14-drive raid10 array.

The numbers are all megabytes/sec transferred (read or written), summed
for all threads.  Leftmost column is the block size; next column is the
number of concurrent threads of the same type.  And the columns are
tests: linear read, random read, linear write, random write, and
concurrent random read and write.

For a raw device:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  18.3   0.8  14.5   9.6   0.1/  9.1
        4         2.5         9.4   0.4/  8.4
       32        10.0         9.3   4.7/  5.4
  16k   1  59.4   2.5  49.9  35.7   0.3/ 34.7
        4        10.3        36.1   1.5/ 31.4
       32        38.5        36.2  17.5/ 20.4
  64k   1 118.4   9.1 136.0 106.5   1.1/105.8
        4        37.7       108.5   4.7/102.6
       32       153.0       108.5  57.9/ 73.3
 128k   1 125.9  16.5 138.8 125.8   1.1/125.6
        4        68.7       128.7   6.3/122.8
       32       277.0       128.7  70.3/ 98.6
1024k   1  89.9  81.2 138.9 134.4   5.0/132.3
        4       254.7       137.6  19.2/127.1
       32       390.7       137.5 117.2/ 90.1

For ext4fs, 1Tb file, default mount options:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  15.7   0.6  15.4   9.4   0.0/  9.0
        4         2.6         9.3   0.0/  8.9
       32        10.0         9.3   0.0/  8.9
  16k   1  47.6   2.5  53.2  34.6   0.1/ 33.6
        4        10.2        34.6   0.0/ 33.5
       32        39.9        34.8   0.1/ 33.6
  64k   1 100.5   9.0 137.0 106.2   0.2/105.8
        4        37.8       107.8   0.1/106.1
       32       153.9       107.8   0.2/105.9
 128k   1 115.4  16.3 138.6 125.2   0.3/125.3
        4        68.8       127.8   0.2/125.6
       32       274.6       127.8   0.2/126.2
1024k   1 124.5  54.2 138.9 133.6   1.0/133.3
        4       159.5       136.6   0.2/134.3
       32       349.7       136.5   0.3/133.6

And for a 1tb file on ext4fs with dioread_nolock:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  15.7   0.6  14.6   9.4   0.1/  9.0
        4         2.6         9.4   0.3/  8.6
       32        10.0         9.4   4.5/  5.3
  16k   1  50.9   2.4  56.7  36.0   0.3/ 35.2
        4        10.1        36.4   1.5/ 34.6
       32        38.7        36.4  17.3/ 21.0
  64k   1  95.2   8.9 136.5 106.8   1.0/106.3
        4        37.7       108.4   5.2/103.3
       32       152.7       108.6  57.4/ 74.0
 128k   1 115.1  16.3 138.8 125.8   1.2/126.4
        4        68.9       128.5   5.7/124.0
       32       276.1       128.6  70.8/ 98.5
1024k   1 128.5  81.9 138.9 134.4   5.1/132.3
        4       253.4       137.4  19.1/126.8
       32       385.1       137.4 111.7/ 92.3

These are complete test results.  First 4 result
columns are merely identical, the difference is
within last column.  Here they are together:

BlkSz Trd     Raw      Ext4nolock  Ext4dflt
   4k   1   0.1/  9.1   0.1/  9.0  0.0/  9.0
        4   0.4/  8.4   0.3/  8.6  0.0/  8.9
       32   4.7/  5.4   4.5/  5.3  0.0/  8.9
  16k   1   0.3/ 34.7   0.3/ 35.2  0.1/ 33.6
        4   1.5/ 31.4   1.5/ 34.6  0.0/ 33.5
       32  17.5/ 20.4  17.3/ 21.0  0.1/ 33.6
  64k   1   1.1/105.8   1.0/106.3  0.2/105.8
        4   4.7/102.6   5.2/103.3  0.1/106.1
       32  57.9/ 73.3  57.4/ 74.0  0.2/105.9
 128k   1   1.1/125.6   1.2/126.4  0.3/125.3
        4   6.3/122.8   5.7/124.0  0.2/125.6
       32  70.3/ 98.6  70.8/ 98.5  0.2/126.2
1024k   1   5.0/132.3   5.1/132.3  1.0/133.3
        4  19.2/127.1  19.1/126.8  0.2/134.3
       32 117.2/ 90.1 111.7/ 92.3  0.3/133.6

Ext4 with dioread_nolock (middle column) behaves close to
raw device.  But default ext4 greatly prefers writes over
reads, reads are almost non-existent.

This is, again, more or less a microbenchmark.  Where it
come from is my attempt to simulate an (oracle) database
workload (many years ago, when larger and more standard
now benchmarks weren't (freely) available).  And there,
on a busy DB, the difference is quite well-visible.
In short, any writer makes all readers to wait.  Once
we start writing something, all users immediately notice.
With dioread_nolock they don't complain anymore.

There's some more background around this all.  Right
now I'm evaluating a new machine for our current database.
Old hardware had 2Gb RAM so it had _significant_ memory
pressure, and lots of stuff weren't able to be cached.
New machine has 128Gb of RAM, which will ensure that
all important stuff is in cache.  So the effect of this
read/write disbalance will be much less visible.

For example, we've a dictionary (several tables) with
addresses - towns, streets, even buildings.  When they
enter customer information they search in these dicts.
With current 2Gb memory thses dictionaries can't be
kept in memory, so they gets read from disk again every
time someone enters customer information, and this is
what they do all the time.  So no doubt disk access is
very important here.

On a new hardware, obviously, all these dictionaries will
be in memory after first access, so even if all reads will
wait till any write completes, it wont be as dramatic as
it is now.

That to say, -- maybe I'm really paying too much attention
for a wrong problem.  So far, on a new machine, I don't see
actual noticeable difference between dioread_nolock and
without that option.

(BTW, I found no way to remount a filesystem to EXclude
that option, I have to umount and mount it in order to
switch from using dioread_nolock to not using it.  Is
there a way?)

Thanks,

/mjt

> We are based on RHEL6, and dioread_nolock isn't there by now and a large
> number of our product system use direct read and buffer write. So if
> your test proves to be promising, I guess our company can arrange some
> resources to try to work it out.
> 
> Thanks
> Tao

