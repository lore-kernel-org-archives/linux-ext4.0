From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 25 Nov 2010 09:44:15 -0500
Message-ID: <4CEE763F.9050902@teksavvy.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	<20101118141957.GK6178@parisc-linux.org>	<20101118142918.GA18510@infradead.org>	<1290100750.3041.72.camel@mulgrave.site>	<alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>	<1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com>	<20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com>	<alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>	<20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com> <yq18w0ini9l.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:23278 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133Ab0KYOoS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 09:44:18 -0500
In-Reply-To: <yq18w0ini9l.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-24 11:23 PM, Martin K. Petersen wrote:
>>>>>> "Mark" == Mark Lord<kernel@teksavvy.com>  writes:
>
> Mark>  But mke2fs probably is NOT doing a "single big discard", because
> Mark>  for SATA the TRIM command is limited to 64K sectors per
> Mark>  range.. and the in-kernel TRIM code only ever does single ranges..
>
> How many times must I reiterate that this is not true?

> Due to various limitations in the way the block layer works we can not
> clear LBA 10 to 20 and LBA 40 to 50 in one command. We don't have an
> infrastructure in place that allows us to operate on several discrete
> areas in one request.
>
> But for contiguous areas we will cram as many ranges entries in as we
> can fit in the TRIM payload. This means we'll issue one TRIM command for
> every 2 GiB minus change (65535*64*512 / 1048576 = 2047 MiB).

Once, will do, thanks.
That's the first time I've read it here with sufficient explanation.
You have my apologies if you've attempted it earlier.

Thanks!
