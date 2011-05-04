From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Wed, 04 May 2011 12:50:57 -0400
Message-ID: <yq1k4e6z9xq.fsf@sermon.lab.mkp.net>
References: <20110429122454.GL32370@agk-dp.fab.redhat.com>
	<alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
	<20110502081308.GC8642@agk-dp.fab.redhat.com>
	<20110502081925.GA11312@infradead.org>
	<alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
	<yq1bozl420p.fsf@sermon.lab.mkp.net>
	<alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
	<yq1tydd2g5h.fsf@sermon.lab.mkp.net>
	<alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com>
	<yq1wri6zel9.fsf@sermon.lab.mkp.net>
	<20110504160231.GD31241@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Lukas Czerner <lczerner@redhat.com>, sandeen@redhat.com,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51960 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1EDQvP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 May 2011 12:51:15 -0400
In-Reply-To: <20110504160231.GD31241@redhat.com> (Mike Snitzer's message of
	"Wed, 4 May 2011 12:02:32 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> lim->discard_zeroes_data = -1; was suspect to me too.
Mike> But why default to 1 here?

Because otherwise DM would default to having dzd to "unsupported",
meaning the feature would never be turned on regardless of the bottom
device capabilities.

The old approach used the -1 value to indicate "has not been set". That
was only really intended as a value for the stacking drivers, not for
the LLDs. It was a bit of a hack and I'd rather deal with dzd the same
way as we do with clustering.


>> @@ -166,6 +166,7 @@ void blk_queue_make_request(struct request_queue
>> *q, make_request_fn *mfn)
>> 
>> blk_set_default_limits(&q->limits);
>> blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
>> + q->limits.discard_zeroes_data = 0;
>> 
>> /*
>> * by default assume old behaviour and bounce for any highmem page

Mike> Only to then reset to 0 here?  Shouldn't we default to 0 and only
Mike> set to 1 where applicable (e.g. sd_config_discard)?

My first approach was to set it in dm-table.c before stacking. But I
thought it was icky to have the stacking driver ask for defaults and
then have to tweak them for things to work correctly.

The other option is to have blk_set_default_stacking_limits(). Or we
could add a flag to blk_set_default_limits to indicate whether this is a
LLD or a stacking driver.

We already special-case BLK_SAFE_MAX_SECTORS when setting the request
function. And that's the only non-stacking user of the default limits
call. So that's why I disabled dzd there. Since this is a stable bugfix
I also wanted to keep it small and simple. But I'm totally open to
suggestions.

-- 
Martin K. Petersen	Oracle Linux Engineering
