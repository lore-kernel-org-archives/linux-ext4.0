From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 21:37:58 -0700
Message-ID: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com> <20140613031538.GR4453@dastard> <20140613033029.GS4453@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34299 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaFMEiT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2014 00:38:19 -0400
Received: by mail-ob0-f177.google.com with SMTP id uy5so2286420obc.36
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2014 21:38:19 -0700 (PDT)
In-Reply-To: <20140613033029.GS4453@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2014 at 8:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jun 13, 2014 at 01:15:38PM +1000, Dave Chinner wrote:
>> Indeed, mixing -o discard and SFITRIM is a recipe for
>> confusion and leakage - "but I used secure trim on the device!" -
>> and so all discards either have to be secure or not.

The idea was to keep on not using -o discard. And move from FITRIM to SFITRIM.

> Oh, and while I think of it secure discard at the filesystem level
> isn't even a guarantee that you'll get rid of all stale references
> to a sector - if the filesystem has freed and then re-allocated a
> block without having gone through a discard cycle on that block,
> then the underlying device may have old copies of the block that it
> hasn't garbage collected and SFITRIM won't clean those up because it
> won't ask to trim in-use blocks....

Arg. So, if understand this correctly, if the eMMC chip won't get a
secure discard/trim of a block that gets reassigned to the FS, then
data duplicates within the eMMC related to that block are not cleared,
and the next SFITRIM won't even reach that block or the duplicates as
the FS says they are in use.


> So, really, secure trim from a filesystem perspective can leak stale
> data at multiple layers....

.. back to the drawing board to evaluate how much leakage we can live
with or maybe go down a path of fibmap + some secure form of erase
(eMMC level secure trim).

Thanks for now.
--
