From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 22:44:33 -0500
Message-ID: <4CE5F2A1.2000009@teksavvy.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com> <4CE59E57.2090009@teksavvy.com> <1290117009.11007.42.camel@mulgrave.site> <4CE5A386.7000105@teksavvy.com> <20101119013301.GU3290@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	James Bottomley <James.Bottomley@suse.de>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:60745 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823Ab0KSDof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 22:44:35 -0500
In-Reply-To: <20101119013301.GU3290@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-18 08:33 PM, Ted Ts'o wrote:
>>>
>>> Before we go gung ho on this, there's no evidence that N discontiguous
>>> ranges in one command are any better than the ranges sent N times ...
>>> the same amount of erase overhead gets sent on SSDs.
>>
>> No, we do have evidence:  execution time of the TRIM commands on the SSD.
>>
>> The one-range-at-a-time is incredibly slow compared to multiple
>> ranges at a time.  That slowness comes from somewhere, with about
>> 99.9% certainty that it is due to the drive performing slow flash
>> erase cycles.
>
> Mark, I think you are over-generalizing here.  You have observed with
> some number of flash drives --- maybe only one, but I don't know that
> for sure --- that TRIM is slow.  Even if we grant that you are correct
> in your conclusion that it is because the drive is doing slow flash
> erase cycles (and I don't completely accept that; I haven't seen your
> your measurements since we know that any kind of command that requires
> a queue drain/flush before it can execute is going to be slow, and I
> don't know what kind of _slow_ you are observing).

I do this stuff on modest hardware:  ata_piix.
There is NO QUEUE TO FLUSH.

So one might expect TRIM to operate at the same speed as ordinary WRITEs.
But it doesn't.  When I measured this in detail (and things have not changed
much since then), we were talking 10s of milliseconds to 100s of milliseconds
per TRIM command.

The only possible explanation for that would be waiting on flash erase commands.

Cheers
