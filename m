From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 12:04:31 -0800
Message-ID: <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <1290102098.3041.77.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: James Bottomley <James.Bottomley@suse.de>,
	Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41733 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0KRULX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 15:11:23 -0500
In-Reply-To: <1290102098.3041.77.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adding Mark Lord in CC:

On Thu, Nov 18, 2010 at 9:41 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Thu, 2010-11-18 at 12:22 -0500, Jeff Moyer wrote:
>> James Bottomley <James.Bottomley@suse.de> writes:
>>
>> > Not stepping into the debate: I'm happy to see punch go to the map=
ping
>> > data and FITRIM pick it up later.
>> >
>> > However, I think it's time to question whether we actually still w=
ant to
>> > allow online discard at all. =A0Most of the benchmarks show it to =
be a net
>>
>> Define online discard, please.
>
> Trims emitted inline at the FS operates (mount option -o discard)
>
>> > lose to almost everything (either SSD or Thinly Provisioned arrays=
), so
>> > it's become an "enable this to degrade performance" option with no
>> > upside.
>>
>> Some SSDs very much require TRIMming to perform well as they age. =A0=
If
>> you're suggesting that we move from doing discards in journal commit=
s to
>> a batched discard, like the one Lukas implemented, then I think that=
's
>> fine. =A0If we need to reintroduce the finer-grained discards due to=
 some
>> hardware changes in the future, we can always do that.
>
> Right, I'm suggesting we just rely on offline methods. =A0Regardless =
of
> what happens to FITRIM, we have wiper.sh now (although it does requir=
e
> unmounted use for most of the less than modern fs).
>
> James

I'm a fan of wiper.sh, but afaik it still cannot address a
multi-spindle LVM setup, Nor a MDraid setup.  etc.

That's because it bypasses the block stack and talks directly to the
devices.  Thus it doesn't get the benefit of all the logical to
physical sector remapping handled via the block stack.

Mark, please correct me if I'm wrong.

The LVM and MDraid setup are important to support, and only "mount -o
discard" and Lucas's FITRIM support them.

So afaik we have 3 options, each with an opportunity for improvement:

1) mount -o discard - needs kernel tuning / new hardware to be a
performance win.

2) FITRIM doesn't leverage the fact the a TRIM command can handle
multiple ranges per TRIM command payload.  I haven't seen any FITRIM
vs. wiper.sh benchmarks, so I don't know what impact that has in
practice.  Mark Lord thought that this lacking feature would cause
=46ITRIM to take minutes or hours with some hardware.  Especially early
generation SSDs.

3) wiper.sh does leverage the multiple ranges per TRIM command, but it
really needs a new block layer interface that would allow it to push
discard commands into the kernel via the block layer, not just down at
the physical drive layer.  The interface should accept multiple ranges
per invocation and trigger TRIM commands to the SSD that have have a
multi-range discard payload.

So it seems that for now keeping all 3 is best.  My personal hope is
that the block layer grows the ability to accept multirange discard
requests and  FITRIM is updated to leverage it.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
