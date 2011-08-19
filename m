From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 19 Aug 2011 10:55:02 -0700
Message-ID: <CAFgt=MDE9SB6TuzZ7vNF5bqQv_ugY7hk7=phidvRdrts8n4Jjw@mail.gmail.com>
References: <4E48390E.9050102@msgid.tls.msk.ru>
	<4E488625.609@tao.ma>
	<4E48D231.5060807@msgid.tls.msk.ru>
	<4E48DF31.4050603@msgid.tls.msk.ru>
	<CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
	<20110816135325.GD23416@quack.suse.cz>
	<4E4A86D0.2070300@tao.ma>
	<CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
	<4E4AEF13.7070504@msgid.tls.msk.ru>
	<CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com>
	<20110817170236.GB6901@thunk.org>
	<4E4CB5F0.6000202@msgid.tls.msk.ru>
	<4E4DD613.8050700@tao.ma>
	<4E4E0B31.3000601@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, "Ted Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1HSRzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2011 13:55:07 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id p7JHt47A014490
	for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 10:55:04 -0700
Received: from yxi11 (yxi11.prod.google.com [10.190.3.11])
	by wpaz5.hot.corp.google.com with ESMTP id p7JHt3QC029422
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 10:55:03 -0700
Received: by yxi11 with SMTP id 11so3399584yxi.11
        for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 10:55:03 -0700 (PDT)
In-Reply-To: <4E4E0B31.3000601@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2011 at 12:05 AM, Michael Tokarev <mjt@tls.msk.ru> wrot=
e:
> On 19.08.2011 07:18, Tao Ma wrote:
>> Hi Michael,
>> On 08/18/2011 02:49 PM, Michael Tokarev wrote:
> []
>>> What about current situation, how do you think - should it be ignor=
ed
>>> for now, having in mind that dioread_nolock isn't used often (but i=
t
>>> gives _serious_ difference in read speed), or, short term, fix this
>>> very case which have real-life impact already, while implementing a
>>> long-term solution?
>
>> So could you please share with us how you test and your test result
>> with/without dioread_nolock? A quick test with fio and intel ssd doe=
s't
>> see much improvement here.
>
> I used my home-grown quick-n-dirty microbenchmark for years to measur=
e
> i/o subsystem performance. =A0Here are the results from 3.0 kernel on
> some Hitachi NAS (FC, on brocade adaptors), 14-drive raid10 array.
>
> The numbers are all megabytes/sec transferred (read or written), summ=
ed
> for all threads. =A0Leftmost column is the block size; next column is=
 the
> number of concurrent threads of the same type. =A0And the columns are
> tests: linear read, random read, linear write, random write, and
> concurrent random read and write.
>
> For a raw device:
>
> BlkSz Trd linRd rndRd linWr rndWr =A0rndR/W
> =A0 4k =A0 1 =A018.3 =A0 0.8 =A014.5 =A0 9.6 =A0 0.1/ =A09.1
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A0 2.5 =A0 =A0 =A0 =A0 9.4 =A0 0.4/ =A0=
8.4
> =A0 =A0 =A0 32 =A0 =A0 =A0 =A010.0 =A0 =A0 =A0 =A0 9.3 =A0 4.7/ =A05.=
4
> =A016k =A0 1 =A059.4 =A0 2.5 =A049.9 =A035.7 =A0 0.3/ 34.7
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A010.3 =A0 =A0 =A0 =A036.1 =A0 1.5/ 31.=
4
> =A0 =A0 =A0 32 =A0 =A0 =A0 =A038.5 =A0 =A0 =A0 =A036.2 =A017.5/ 20.4
> =A064k =A0 1 118.4 =A0 9.1 136.0 106.5 =A0 1.1/105.8
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A037.7 =A0 =A0 =A0 108.5 =A0 4.7/102.6
> =A0 =A0 =A0 32 =A0 =A0 =A0 153.0 =A0 =A0 =A0 108.5 =A057.9/ 73.3
> =A0128k =A0 1 125.9 =A016.5 138.8 125.8 =A0 1.1/125.6
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A068.7 =A0 =A0 =A0 128.7 =A0 6.3/122.8
> =A0 =A0 =A0 32 =A0 =A0 =A0 277.0 =A0 =A0 =A0 128.7 =A070.3/ 98.6
> 1024k =A0 1 =A089.9 =A081.2 138.9 134.4 =A0 5.0/132.3
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 254.7 =A0 =A0 =A0 137.6 =A019.2/127.1
> =A0 =A0 =A0 32 =A0 =A0 =A0 390.7 =A0 =A0 =A0 137.5 117.2/ 90.1
>
> For ext4fs, 1Tb file, default mount options:
>
> BlkSz Trd linRd rndRd linWr rndWr =A0rndR/W
> =A0 4k =A0 1 =A015.7 =A0 0.6 =A015.4 =A0 9.4 =A0 0.0/ =A09.0
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A0 2.6 =A0 =A0 =A0 =A0 9.3 =A0 0.0/ =A0=
8.9
> =A0 =A0 =A0 32 =A0 =A0 =A0 =A010.0 =A0 =A0 =A0 =A0 9.3 =A0 0.0/ =A08.=
9
> =A016k =A0 1 =A047.6 =A0 2.5 =A053.2 =A034.6 =A0 0.1/ 33.6
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A010.2 =A0 =A0 =A0 =A034.6 =A0 0.0/ 33.=
5
> =A0 =A0 =A0 32 =A0 =A0 =A0 =A039.9 =A0 =A0 =A0 =A034.8 =A0 0.1/ 33.6
> =A064k =A0 1 100.5 =A0 9.0 137.0 106.2 =A0 0.2/105.8
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A037.8 =A0 =A0 =A0 107.8 =A0 0.1/106.1
> =A0 =A0 =A0 32 =A0 =A0 =A0 153.9 =A0 =A0 =A0 107.8 =A0 0.2/105.9
> =A0128k =A0 1 115.4 =A016.3 138.6 125.2 =A0 0.3/125.3
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A068.8 =A0 =A0 =A0 127.8 =A0 0.2/125.6
> =A0 =A0 =A0 32 =A0 =A0 =A0 274.6 =A0 =A0 =A0 127.8 =A0 0.2/126.2
> 1024k =A0 1 124.5 =A054.2 138.9 133.6 =A0 1.0/133.3
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 159.5 =A0 =A0 =A0 136.6 =A0 0.2/134.3
> =A0 =A0 =A0 32 =A0 =A0 =A0 349.7 =A0 =A0 =A0 136.5 =A0 0.3/133.6
>
> And for a 1tb file on ext4fs with dioread_nolock:
>
> BlkSz Trd linRd rndRd linWr rndWr =A0rndR/W
> =A0 4k =A0 1 =A015.7 =A0 0.6 =A014.6 =A0 9.4 =A0 0.1/ =A09.0
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A0 2.6 =A0 =A0 =A0 =A0 9.4 =A0 0.3/ =A0=
8.6
> =A0 =A0 =A0 32 =A0 =A0 =A0 =A010.0 =A0 =A0 =A0 =A0 9.4 =A0 4.5/ =A05.=
3
> =A016k =A0 1 =A050.9 =A0 2.4 =A056.7 =A036.0 =A0 0.3/ 35.2
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A010.1 =A0 =A0 =A0 =A036.4 =A0 1.5/ 34.=
6
> =A0 =A0 =A0 32 =A0 =A0 =A0 =A038.7 =A0 =A0 =A0 =A036.4 =A017.3/ 21.0
> =A064k =A0 1 =A095.2 =A0 8.9 136.5 106.8 =A0 1.0/106.3
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A037.7 =A0 =A0 =A0 108.4 =A0 5.2/103.3
> =A0 =A0 =A0 32 =A0 =A0 =A0 152.7 =A0 =A0 =A0 108.6 =A057.4/ 74.0
> =A0128k =A0 1 115.1 =A016.3 138.8 125.8 =A0 1.2/126.4
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A068.9 =A0 =A0 =A0 128.5 =A0 5.7/124.0
> =A0 =A0 =A0 32 =A0 =A0 =A0 276.1 =A0 =A0 =A0 128.6 =A070.8/ 98.5
> 1024k =A0 1 128.5 =A081.9 138.9 134.4 =A0 5.1/132.3
> =A0 =A0 =A0 =A04 =A0 =A0 =A0 253.4 =A0 =A0 =A0 137.4 =A019.1/126.8
> =A0 =A0 =A0 32 =A0 =A0 =A0 385.1 =A0 =A0 =A0 137.4 111.7/ 92.3
>
> These are complete test results. =A0First 4 result
> columns are merely identical, the difference is
> within last column. =A0Here they are together:
>
> BlkSz Trd =A0 =A0 Raw =A0 =A0 =A0Ext4nolock =A0Ext4dflt
> =A0 4k =A0 1 =A0 0.1/ =A09.1 =A0 0.1/ =A09.0 =A00.0/ =A09.0
> =A0 =A0 =A0 =A04 =A0 0.4/ =A08.4 =A0 0.3/ =A08.6 =A00.0/ =A08.9
> =A0 =A0 =A0 32 =A0 4.7/ =A05.4 =A0 4.5/ =A05.3 =A00.0/ =A08.9
> =A016k =A0 1 =A0 0.3/ 34.7 =A0 0.3/ 35.2 =A00.1/ 33.6
> =A0 =A0 =A0 =A04 =A0 1.5/ 31.4 =A0 1.5/ 34.6 =A00.0/ 33.5
> =A0 =A0 =A0 32 =A017.5/ 20.4 =A017.3/ 21.0 =A00.1/ 33.6
> =A064k =A0 1 =A0 1.1/105.8 =A0 1.0/106.3 =A00.2/105.8
> =A0 =A0 =A0 =A04 =A0 4.7/102.6 =A0 5.2/103.3 =A00.1/106.1
> =A0 =A0 =A0 32 =A057.9/ 73.3 =A057.4/ 74.0 =A00.2/105.9
> =A0128k =A0 1 =A0 1.1/125.6 =A0 1.2/126.4 =A00.3/125.3
> =A0 =A0 =A0 =A04 =A0 6.3/122.8 =A0 5.7/124.0 =A00.2/125.6
> =A0 =A0 =A0 32 =A070.3/ 98.6 =A070.8/ 98.5 =A00.2/126.2
> 1024k =A0 1 =A0 5.0/132.3 =A0 5.1/132.3 =A01.0/133.3
> =A0 =A0 =A0 =A04 =A019.2/127.1 =A019.1/126.8 =A00.2/134.3
> =A0 =A0 =A0 32 117.2/ 90.1 111.7/ 92.3 =A00.3/133.6
>
> Ext4 with dioread_nolock (middle column) behaves close to
> raw device. =A0But default ext4 greatly prefers writes over
> reads, reads are almost non-existent.
>
> This is, again, more or less a microbenchmark. =A0Where it
> come from is my attempt to simulate an (oracle) database
> workload (many years ago, when larger and more standard
> now benchmarks weren't (freely) available). =A0And there,
> on a busy DB, the difference is quite well-visible.
> In short, any writer makes all readers to wait. =A0Once
> we start writing something, all users immediately notice.
> With dioread_nolock they don't complain anymore.
>
> There's some more background around this all. =A0Right
> now I'm evaluating a new machine for our current database.
> Old hardware had 2Gb RAM so it had _significant_ memory
> pressure, and lots of stuff weren't able to be cached.
> New machine has 128Gb of RAM, which will ensure that
> all important stuff is in cache. =A0So the effect of this
> read/write disbalance will be much less visible.
>
> For example, we've a dictionary (several tables) with
> addresses - towns, streets, even buildings. =A0When they
> enter customer information they search in these dicts.
> With current 2Gb memory thses dictionaries can't be
> kept in memory, so they gets read from disk again every
> time someone enters customer information, and this is
> what they do all the time. =A0So no doubt disk access is
> very important here.
>
> On a new hardware, obviously, all these dictionaries will
> be in memory after first access, so even if all reads will
> wait till any write completes, it wont be as dramatic as
> it is now.
>
> That to say, -- maybe I'm really paying too much attention
> for a wrong problem. =A0So far, on a new machine, I don't see
> actual noticeable difference between dioread_nolock and
> without that option.
>
> (BTW, I found no way to remount a filesystem to EXclude
> that option, I have to umount and mount it in order to
> switch from using dioread_nolock to not using it. =A0Is
> there a way?)
I think the command to do this is:
mount -o remount,dioread_lock /dev/xxx <mountpoint>

Now looking at this, I guess it is not very intuitive that the option t=
o
turn off dioread_nolock is dioread_lock instead of nodioread_nolock,
but nodioread_nolock does look ugly. Maybe we should try to support
both ways.

Jiaying
>
> Thanks,
>
> /mjt
>
>> We are based on RHEL6, and dioread_nolock isn't there by now and a l=
arge
>> number of our product system use direct read and buffer write. So if
>> your test proves to be promising, I guess our company can arrange so=
me
>> resources to try to work it out.
>>
>> Thanks
>> Tao
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
