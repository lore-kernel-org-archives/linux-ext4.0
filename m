From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 09:01:02 -0500
Message-ID: <4CE6831E.4020606@teksavvy.com>
References: <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com> <4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net> <4CE5C616.7070706@teksavvy.com> <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com> <20101119115516.GA1152@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:28003 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752915Ab0KSOBF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:01:05 -0500
In-Reply-To: <20101119115516.GA1152@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 06:55 AM, Christoph Hellwig wrote:
> On Thu, Nov 18, 2010 at 05:16:36PM -0800, Greg Freemyer wrote:
>> I agree with Mark.  When you say "make coalescing work" it sounds like
>> major overkill.
>>
>> FITRIM should be able to lock a group of non-contiguous free ranges,
>> send them down to the block layer as a single pre-coalesced set, and
>> the block layer just needs to pass it on in a synchronous way.  Then
>> when that group of ranges is discarded, FITRIM releases the locks.
>
> Given that you know the Linux I/O stack and hardware so well may I
> volunteer you to implement it?

That is my intent already, thanks.  Just needs time, perhaps this winter.

I think a reasonable approach would be to modify the existing interfaces
so that the LLD can report a "max discard ranges per command" back up
the stack.

This way, libata could report a max of say, 64 ranges per "discard" (trim),
and DM/RAID could simply (for now) report a max of one range per discard.

Way up at the FITRIM level, code could interrogate the "discard" limit
for the device holding the fs, and construct the discard commands such that
they respect that limit.  For a filesystem on DM/RAID, we would (for now)
end up with single-range discards, no change from the present.

For the much more common case of end-user SATA SSDs, though, we would
suddenly get multi-range trims working with probably very little effort.

That's the plan.  Feel free to beat me to it -- you've been working on
the I/O stack nearly as long as I have (since 1992), and I expect you
know it far better by now, too!  ;)

Cheers
