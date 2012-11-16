From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 settings in an embedded system
Date: Fri, 16 Nov 2012 09:40:13 -0600
Message-ID: <50A65E5D.7040305@redhat.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com> <1352968933.2221.16.camel@sauron.fi.intel.com> <CAA0+VHyODd+hsSL6FBqcLGb_r3ViHmL78ay=8k5CJeP0=Z2k7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dedekind1@gmail.com,
	"Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>, linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2KPQ0I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2012 11:26:08 -0500
In-Reply-To: <CAA0+VHyODd+hsSL6FBqcLGb_r3ViHmL78ay=8k5CJeP0=Z2k7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/15/12 4:01 AM, Andrey Sidorov wrote:
> On Thu, Nov 15, 2012 at 12:42 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 
>> We conducted some 3 years ago. Results were quite good for ext4 - in
>> many cases it could recover without a need to run ckfs.ext4, sometimes
>> it was not mountable, but ckfs.ext4 helped.
>>
>> On the opposite, ext3 constantly required ckfs.ext3, and sometimes died
>> so badly that even ckfs.ext3 could not recover it.

Depending on your storage, if barriers were not enabled on your storage,
this is expected.  Evaporating write caches on power cut do not play well
with journaling guarantees.

https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/writebarr.html

Barriers were not made default on ext3 until 2011, in kernel v3.1,
astonishingly.  So it makes sense that ext3 fared worse than ext4.

Unplayable journals are not surprising with non-battery-backed
writeback caches, no explicit cache flushing, and power loss.

> We ran about 6000 cycles of power resets with linux 2.6.37. The test
> was to run 3 tar processes unpacking linux kernel archive and power
> off after about 15 seconds. There were only 3 failures when file
> system couldn't be mounted, but that was due to HDD failure
> (unreadable sector in journal area). e2fsck successfully recovered
> those corruptions. As for software itself, there was no single issue
> and we never needed to run fsck after power loss. So I'd say that ext4
> is very tolerant to power losses at least in 2.6.37 assuming barriers
> and ordered data mode. I however understand this test is quite basic
> and any way results can be different for different kernels.

Right - barriers.

Of course you probably did lose *file* data even if the fs metadata
was correct.

Remember that journaling ensures a consistent metadata structure, but
does not guarantee data integrity.

-Eric
