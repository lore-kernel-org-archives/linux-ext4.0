From: jim owens <owens6336@gmail.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 08 Mar 2010 15:48:33 -0500
Message-ID: <4B9562A1.2020205@gmail.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>            <4B952437.8020607@gmail.com> <4987.1268077130@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Newall <davidn@davidnewall.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4987.1268077130@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 08 Mar 2010 11:22:15 EST, jim owens said:
> 
>> No.  Your logic would be correct if rotating disks had
>> similar speed at all locations.  Current disks are much
>> faster at the 0 end than at the middle or highest address.
>>
>> It is not unusual to see 2x difference in transfer speed
>> so you always want the important stuff as low as possible.
> 
> On the flip side, seek time is so much larger than the time spent
> actually reading that minimizing the seeks will improve total throughput
> more.  Sure, maybe you spend 0.05ms reading instead of 0.1ms - but if
> the seek took 0.75ms rather than 0.5ms you're still in the hole.

Agree that seek proximity is important, but seeking at the low end
for N blocks is also faster than seeking the same N blocks at the
slow high end of the disk. 

So my point is you want to pack the data together when you can
at the low address end of the disk to maximize performance.
And we should include some free space in the fast zone because
much of our performance involves short-lived writes.

If you are filling and accessing all of the disk, then maybe
"pack from the middle" will average out better, but we hope
most filesystems have a small hot subset.  If you are often
accessing outside the hot zone a lot then you probably will
get end-to-end seek penalties anyway if you are defragging
to an "old, free, hot, free, old" layout.

jim 
