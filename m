From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext4: batched discard support
Date: Mon, 19 Apr 2010 13:58:20 -0400
Message-ID: <l2z87f94c371004191058pb88b1b89va325ceffb83ba604@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com>
	 <4BCC8511.2070402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Mark Lord <liml@rtr.ca>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34006 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0DSR6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 13:58:20 -0400
Received: by pwj9 with SMTP id 9so3588914pwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 10:58:20 -0700 (PDT)
In-Reply-To: <4BCC8511.2070402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 19, 2010 at 12:30 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Greg Freemyer wrote:
>> Adding Mark Lord in cc.
>>
>> He wrote a preliminary discard solution last summer. =A0I'm not sure=
 how
>> it has progressed.
>
> The difference here is that Mark's stuff wasn't as tightly integrated
> with the kernel, IIRC. =A0What I saw was more at a user level - make =
a big
> file, map it, discard all the blocks, unlink the file.
>
> It was a good first step, but I think we can do a lot better by using
> fs-specific calls to be efficient & targeted about the discards.
>
> Christoph has a similar approach for XFS, FWIW.
>
> -Eric

I haven't looked closely at this patch, but I recall Mark consolidated
numerous discontinuous trim/discard/unmap ranges into a single command
to the SSD drive.

That was why he felt he was getting superior performance.  ie. There
was an overhead per command to the drive that was eliminated if a
single more complex command with multiple ranges went to the SSD
drive.

But he's the one that did the work and the benchmarking, so I'll let
him take it from here, especially if I mis-understood what he was
doing.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
