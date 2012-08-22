From: Dan Williams <djbw@fb.com>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Wed, 22 Aug 2012 13:47:07 -0700
Message-ID: <CAA9_cmc4t_P3p-72iZx4UALNe3fupVqBKvvsvCtMH6G3HZUdww@mail.gmail.com>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060915.GB28786@localhost>
	<20120817134039.GB11439@thunk.org>
	<20120817142526.GA1059@localhost>
	<20120822035702.GF2570@yliu-dev.sh.intel.com>
	<20120822160025.272188d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Li Shaohua <shli@fusionio.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
	linux RAID <linux-raid@vger.kernel.org>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63615 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2HVUrJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Aug 2012 16:47:09 -0400
In-Reply-To: <20120822160025.272188d1@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 21, 2012 at 11:00 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 22 Aug 2012 11:57:02 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
>
>>
>> -#define NR_STRIPES           256
>> +#define NR_STRIPES           1024
>
> Changing one magic number into another magic number might help your case, but
> it not really a general solution.
>
> Possibly making sure that max_nr_stripes is at least some multiple of the
> chunk size might make sense, but I wouldn't want to see a very large multiple.
>
> I thing the problems with RAID5 are deeper than that.  Hopefully I'll figure
> out exactly what the best fix is soon - I'm trying to look into it.
>
> I don't think the size of the cache is a big part of the solution.  I think
> correct scheduling of IO is the real answer.

Not sure if this is what we are seeing here, but we still have the
unresolved fast parity effect whereby slower parity calculation gives
a larger time to coalesce writes.  I saw this effect when playing with
xor offload.

--
Dan
