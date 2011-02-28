From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 15:10:25 +0200
Message-ID: <AANLkTinofyYH02WT=mx4m_sD_4FoUxPQD7OJT8UZh5_b@mail.gmail.com>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
	<20110228101454.GE4834@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45065 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1B1NK0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 08:10:26 -0500
Received: by qyk7 with SMTP id 7so2227354qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 05:10:26 -0800 (PST)
In-Reply-To: <20110228101454.GE4834@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 12:14 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
>
> On Sat, Feb 26, 2011 at 10:40:19PM +0200, Amir Goldstein wrote:
>> This patch skips the orphan cleanup if readonly compatible features
>> would prevent the fs from being mounted (or remounted) readwrite.
>
> I use the "mount readonly" option to, for instance, view/check the
> filesystem to determine wether or not I need to fsck first. I use the
> "readonly" feature to prevent the mounting to be a mistake-prone
> situation. It prevents e.g. applications from dropping temporary files
> in my current directory.
>
> Every time fsck or such a cleanup does something, there is the option
> of the cleanup or fixup being wrong. When you honour the "readonly"
> request from the user, the careful user can go back to the situation
> where he/she started.
>
> If the cleanup/fixup is really neccesary, do so in in-core buffers of
> the filesystem. Write the infrastructure that allows us to have dirty
> buffers that MAY NOT (yet?!?) be written to the device. This will also
> solve the problem of journal recovery on readonly mount of a root
> filesystem. when it has been fscked, and it's remounted rw, we can
> remove the ban on the writeback of the dirty buffers.
>
> So I stronly disagree with your patch: It should not only prevent the
> cleanup when writing is not allows due to ro-compat situation, but
> also when requested by the user.
>

I am not disagreeing with your disagreement, but implementing what
you desire has more implications than my patch, so I rather that my
patch gets merged, because it is mostly-harmless and we can continue
the discussion, whether or not file systems need to honor the readonly
mount option to the word in parallel.

Amir.
