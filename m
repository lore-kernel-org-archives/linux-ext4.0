From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 25 Nov 2010 11:24:22 -0500
Message-ID: <AANLkTi=J_J68+758XOCYp=+YXaU1+yJjRrvBsAeB5eUi@mail.gmail.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com>
 <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
 <20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com>
 <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com> <4CEE7884.5010007@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51861 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0KYQYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 11:24:43 -0500
In-Reply-To: <4CEE7884.5010007@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 25, 2010 at 9:53 AM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-24 11:41 PM, Greg Freemyer wrote:
>>
>> If you see a significant speed difference between mke2fs and running
>> wiper.sh on that same filesystem immediately after formatting, then
>> their is likely a bug worth chasing.
>
>
> You're right. =A0They're both equally slow on a blank Sandforce drive=
,
> taking about 83-90 seconds to TRIM 100GB.
>
> The difference being that mke2fs just sits there with zero indication
> or information as to what the huge delay is.
>
> It's a pity the TRIM commands are so sluggish on the Sandforce.
> It's a generation newer than the original Vertex, and TRIM is way fas=
ter
> on the older Vertex. =A0Not that either of them do it quickly enough =
that
> I'd ever want the kernel doing it automatically "on my behalf".
>
> The strange thing, is that when we TRIM the entire raw device,
> using ATA SECURITY ERASE, it takes less than 2 seconds.
>
> Cheers

Mark,

I'm away from my systems today, but is there an easy way to tweak
wiper.sh or hdparm to cause only a single range per trim command.

I'm curious if for the Sandforce that would still be in the 90 second
range, or closer to 64x that.

Or if there is a readily available userspace tool to invoke FITRIM and
you have a 2.6.37-rc? kernel, you could just time that on a newly
formatted drive.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
