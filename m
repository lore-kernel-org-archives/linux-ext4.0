From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 19:22:01 +0100
Message-ID: <20110228182201.GE20805@quack.suse.cz>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
 <20110228101454.GE4834@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab1B1SWD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 13:22:03 -0500
Content-Disposition: inline
In-Reply-To: <20110228101454.GE4834@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 28-02-11 11:14:55, Rogier Wolff wrote:
> 
> On Sat, Feb 26, 2011 at 10:40:19PM +0200, Amir Goldstein wrote:
> > This patch skips the orphan cleanup if readonly compatible features
> > would prevent the fs from being mounted (or remounted) readwrite.
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
  Mounting (even read-only) without recovering the journal will give you a
view of a corrupted filesystem. Usually not what you want (although I agree
with you that there are occasions where this *is* what you want).

> the filesystem. Write the infrastructure that allows us to have dirty
> buffers that MAY NOT (yet?!?) be written to the device. This will also
> solve the problem of journal recovery on readonly mount of a root
> filesystem. when it has been fscked, and it's remounted rw, we can
> remove the ban on the writeback of the dirty buffers.
  Yes, this would be a nice feature but noone ever got to implementing it.
You are welcome to contribute it :).

> So I stronly disagree with your patch: It should not only prevent the
> cleanup when writing is not allows due to ro-compat situation, but
> also when requested by the user.
  As Amir said, the patch is trivial and a clear improvement. So it goes
in.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
