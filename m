From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 3 Jun 2011 13:25:21 +0900
Message-ID: <BANLkTin7afjph7=GO=K+QcBSaOUf7zJqSw@mail.gmail.com>
References: <20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<4CE59C9E.6050902@teksavvy.com>
	<1290177488-sup-6540@think>
	<4CE68F80.7000607@teksavvy.com>
	<20101119145748.GB27919@infradead.org>
	<4CE695FF.20601@teksavvy.com>
	<20101207092749.GA26100@infradead.org>
	<1291740643-sup-2494@think>
	<BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
	<20110603020615.GZ561@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mark Lord <kernel@teksavvy.com>,
	James Bottomley <james.bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62654 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1FCEZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2011 00:25:23 -0400
In-Reply-To: <20110603020615.GZ561@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 3, 2011 at 11:06 AM, Dave Chinner <david@fromorbit.com> wro=
te:
> On Thu, Jun 02, 2011 at 01:52:12PM +0900, Kyungmin Park wrote:
>> On Wed, Dec 8, 2010 at 1:52 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> > Excerpts from Christoph Hellwig's message of 2010-12-07 04:27:49 -=
0500:
>> >> On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
>> >> > >I really hate to rely on this third party hearsay (from all si=
des), and
>> >> > >have implement TRIM support in qemu now. =A0I'll soon install =
win7 and
>> >> > >will check out the TRIM patters myself.
>> >> >
>> >> > Excellent!
>> >>
>> >> I did a Windows 7 installation under qemu today, and the result i=
s:
>> >
>> > Great, thanks for testing this.
>> >
>> >>
>> >> =A0- it TRIMs the whole device early during the installation
>> >> =A0- after that I see a constant stream of small trims during the
>> >> =A0 =A0installation. =A0It's using lots of non-contiguous ranges =
in a single
>> >> =A0 =A0TRIM command, with sizes down to 8 sectors (4k) for a sing=
le range.
>> >> =A0- after installation there's is some background-trimming going=
 on
>> >> =A0 =A0even when doing no user interaction with the VM at all.
>>
>> Hi Lukas,
>>
>> Now FITRIM is based on user interaction. So how about to implement t=
he
>> AUTO batched discard at kernel level?
>> Idea is same as windows, make a single thread and iterate the
>> superblocks and call the trim.
>
> Surely this the responsibility of a userspace daemon and a config
> file to decide and implement the background trim policy?

It seems to run as crond. BTW, what's config file? time based or behavi=
or?
my rough idea to run at kernel level.

1. Block I/O aware notification.
2. Explicit filesystem call
3. user space request. (same as current)

Thank you,
Kyungmin Park
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
