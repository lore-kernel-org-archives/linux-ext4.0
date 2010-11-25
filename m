From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Wed, 24 Nov 2010 23:41:26 -0500
Message-ID: <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com>
 <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
 <20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com>
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
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62590 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab0KYElr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Nov 2010 23:41:47 -0500
In-Reply-To: <4CEDCE60.9050109@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 24, 2010 at 9:48 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-19 11:30 AM, Ted Ts'o wrote:
>>
>> On Fri, Nov 19, 2010 at 04:44:33PM +0100, Lukas Czerner wrote:
>>>>
>>>> But, oddly, it _is_ the default for mke2fs -t ext4,
>>>> which really threw me for a loop recently.
>>>>
>>>> I though my system had locked up when suddenly everything
>>>> went dead for a very long time (many minutes) while installing a
>>>> new system.
>>
>> Yeah, the assumption was doing a single big discard (which is all
>> mke2fs is doing) should be fast. =A0At least on sanely implemented S=
SD's
>> (i.e., like the Intel X25-M) it should be, since all that should
>> require is a flash write to the global mapping table, declaring all =
of
>> the blocks as free.
>
> But mke2fs probably is NOT doing a "single big discard", because for =
SATA
> the
> TRIM command is limited to 64K sectors per range.. and the in-kernel =
TRIM
> code only ever does single ranges..
>
> So doing a discard over an entire drive-encompassing partition, say..=
 100GB,
> will require 3000+ individual TRIM commands. =A0At (say) 200msecs eac=
h, that
> adds up to about ten minutes of execution time. =A0Or less if the dri=
ve is
> faster than that.
>
> Whereas.. grouping them into 64-ranges per trim, could reduce the exe=
cution
> time down to perhaps 1/50th of that, or in the range of 10-20 seconds
> instead.
>
> Cheers

Mark,

With recent kernels, this is supposed to work as you describe.  ie. 64
contiguous ranges per trim command.

If you see a significant speed difference between mke2fs and running
wiper.sh on that same filesystem immediately after formatting, then
their is likely a bug worth chasing.

Are you seeing an actual speed difference, or just assuming there is
one?  If mke2fs is slower than wiper.sh, what kernel are you testing
with?

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
=A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-=
gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
