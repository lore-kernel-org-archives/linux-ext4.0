From: Alexander Shishkin <alexander.shishckin@gmail.com>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Tue, 12 May 2009 15:49:30 +0300
Message-ID: <71a0d6ff0905120549h628146d8p3def31b09b79199a@mail.gmail.com>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
	 <4A086763.9090907@redhat.com>
	 <20090511182050.GA3209@webber.adilger.int>
	 <4A087202.4010601@redhat.com>
	 <71a0d6ff0905120455x291d7280ybe8d1a562987fd1b@mail.gmail.com>
	 <20090512121305.GL21518@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:49979 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZELMtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 08:49:31 -0400
Received: by bwz22 with SMTP id 22so3248278bwz.37
        for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 05:49:30 -0700 (PDT)
In-Reply-To: <20090512121305.GL21518@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12 May 2009 15:13, Theodore Tso <tytso@mit.edu> wrote:
>> My concern was basically if it is safe to skip zeroing for internal =
journal.
>
> Strictly speaking, no. =C2=A0Most of the time you'll get lucky. =C2=A0=
The place
> where you will get into trouble will be is if there is leftover
> uninitialized garbage (particularly if you are reformatting an
> existing ext3/4 filesystem) that looks like a journal log block, with
> the correct journal transaction number, *and* the system crashes
> before the journal has been completely written through at least once.

So, what Andreas explained yesterday also applies to the internal log
case. I see. Would you say it's possible to prevent this, for instance
somehow say, by means checksums as Andreas suggested?

> What precisely is your concern? =C2=A0Normally the journal isn't that=
 big,
> and it's a contiguous write --- so it doesn't take that long. =C2=A0A=
re you
> worried about the time it takes, or trying to avoid some writes to an
> SSD, or some other concern? =C2=A0If we know it's an SSD, where reads=
 are

It's an mmc and it (mkfs) runs almost two times faster without zeroing
the journal. The only thing I'm worried about is the time that it
takes for mke2fs -j to complete. I've done some caching trickery to
unix_io.c which I'm going to post here separately, but most of the
time seems to be taken by the journal.

> fast, and writes are slow, I suppose we could scan the disk looking
> for potentially dangerous blocks and zero them manually. =C2=A0It's r=
eally
> not clear it's worth the effort though.

Hm. This might work, I'll look into it. Thanks for the idea!

Regards,
--
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
