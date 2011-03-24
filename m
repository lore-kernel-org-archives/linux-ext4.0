From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Thu, 24 Mar 2011 12:34:05 +0200
Message-ID: <AANLkTi=xJNKei5Q_kvEMQ6usLhE6jgy6pmbGBq93gALU@mail.gmail.com>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
	<20110228180950.GD20805@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38397 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1CXKeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2011 06:34:06 -0400
Received: by qwk3 with SMTP id 3so6536308qwk.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2011 03:34:05 -0700 (PDT)
In-Reply-To: <20110228180950.GD20805@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Please apply commit ce654b37 to any stable kernel out there.

The relevant ext4 patch is in Ted's tree and has not reached mainline y=
et.
Ted, can you please add CC: stable to my patch.

Thanks,
Amir.

On Mon, Feb 28, 2011 at 8:09 PM, Jan Kara <jack@suse.cz> wrote:
> On Sat 26-02-11 22:40:19, Amir Goldstein wrote:
>> Orphan cleanup is currently executed even on readonly mount.
>> It deletes inodes and frees blocks, which could be very bad for some
>> RO_COMPAT features, HAS_SNAPSHOT to name one.
>>
>> Now the damage is done, because current stock kernels may
>> corrupt future fs with readonly compatible features,
>> when doing orphan cleanup.
>>
>> This patch skips the orphan cleanup if readonly compatible features
>> would prevent the fs from being mounted (or remounted) readwrite.
> =A0Thanks Amir. I actually took the version Ted committed to ext4 and=
 ported
> it for ext3. Anyway, the patch is in my tree.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
