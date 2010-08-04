From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Wed, 4 Aug 2010 11:26:56 -0400
Message-ID: <AANLkTikmNCLSuc--k=k4mFSGhgn82Q1n1-66SYnGJH-5@mail.gmail.com>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
	<8762zq8lxv.fsf@dmon-lap.sw.ru>
	<alpine.LFD.2.00.1008041704420.2932@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu,
	Mark Lord <kernel@teksavvy.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62657 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0HDP05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Aug 2010 11:26:57 -0400
Received: by ywh1 with SMTP id 1so1999314ywh.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Aug 2010 08:26:56 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1008041704420.2932@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 4, 2010 at 11:13 AM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Wed, 4 Aug 2010, Dmitry Monakhov wrote:
>
>> Lukas Czerner <lczerner@redhat.com> writes:
>>
>> > Adds an filesystem independent ioctl to allow implementation of fi=
le
>> > system batched discard support.
>> >
>> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> > ---
>> > =A0fs/ioctl.c =A0 =A0 =A0 =A0 | =A0 31 +++++++++++++++++++++++++++=
++++
>> > =A0include/linux/fs.h | =A0 =A02 ++
>> > =A02 files changed, 33 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/fs/ioctl.c b/fs/ioctl.c
>> > index 2d140a7..6c01c3c 100644
>> > --- a/fs/ioctl.c
>> > +++ b/fs/ioctl.c
>> > @@ -540,6 +540,33 @@ static int ioctl_fsthaw(struct file *filp)
>> > =A0 =A0 return thaw_super(sb);
>> > =A0}
>> >
>> > +static int ioctl_fstrim(struct file *filp, unsigned long arg)
>> BTW why do we have to trim fs in one shot ?
>> IMHO it is much suitable to provide start,len parameters as we
>> do in most functions(truncate, bdevdiscard, getdents).
>> It allow userspace caller to implement a fancy looking progress bars=
=2E
>
> Hi,
>
> do you think it is really needed when even with todays SSD's it takes
> just a couple of seconds ? And I suppose it will improve in future. B=
ut
> generally I think we can do that..I would like to hear some more
> opinions before I start looking at this.
>
> Thanks.
>
> -Lukas.

Since the proposed patch is not aggregating discards into multiple
ranges per ATA command, I thought some of the non-optimized devices
would take minutes / hours?

If true, a way to control the progress from userspace is important.

If in general it is only going to take a few seconds for a full FITRIM
to run, it is much less important, but I suppose the the RT project
might find even that problematic.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
