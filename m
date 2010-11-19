From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 09:48:12 -0500
Message-ID: <4CE68E2C.9070101@teksavvy.com>
References: <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com> <4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net> <4CE5C616.7070706@teksavvy.com> <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com> <20101119115516.GA1152@infradead.org> <4CE6831E.4020606@teksavvy.com> <20101119140639.GA25488@infradead.org>
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
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:62240 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752255Ab0KSOsU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:48:20 -0500
In-Reply-To: <20101119140639.GA25488@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 09:06 AM, Christoph Hellwig wrote:
> On Fri, Nov 19, 2010 at 09:01:02AM -0500, Mark Lord wrote:
>> Ithink a reasonable approach would be to modify the existing interfaces
>> so that the LLD can report a "max discard ranges per command" back up
>> the stack.
>>
>> This way, libata could report a max of say, 64 ranges per "discard" (trim),
>> and DM/RAID could simply (for now) report a max of one range per discard.
>
> That's certainly the easy way out.  You'll need a good way to actually
> transport the ranges as we can't simply sote them in bi_sector/bi_size
> and adapt the whole block layer to deal with the two types of different
> discards.  Not saying it's impossible, but when I tried it before it
> wasn't pretty.

Yeah.  I think for this to happen is has to be evolutionary,
and the proposal above looks like a reasonable first crack at it.

I'm not sure about the issues on "adapting the block layer" ?
For FITRIM, the blocks being trimmed would be reserved at the fs level,
before issuing the discard for them.  So ordering through the block layer
shouldn't matter much for it.  Does that simplify things?

I see FITRIM just allocating a page to hold the ranges (for the >1 case)
and passing that page down through the layers to libata (or any other
LLD that supports >1 ranges).

??
