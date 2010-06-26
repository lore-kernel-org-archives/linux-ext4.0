From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH, RFC] ext4: Store basic fs error information in the
	superblock
Date: Sat, 26 Jun 2010 04:16:36 +0300
Message-ID: <AANLkTiknXLzOHuYZny1wkQ0b7TGwUOjkGA3RZO88Uc6f@mail.gmail.com>
References: <AANLkTikT18i8QAWassSdBBqps-nheNdwRNcmLfqtzDAr@mail.gmail.com>
	<20100624132745.GH6843@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0FZBQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jun 2010 21:16:38 -0400
Received: by bwz7 with SMTP id 7so897279bwz.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2010 18:16:36 -0700 (PDT)
In-Reply-To: <20100624132745.GH6843@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 24, 2010 at 4:27 PM,  <tytso@mit.edu> wrote:
> True, thanks for pointing that out; the simplest way to solve this fo=
r
> my purposes is to snapshot those superblock fields and restore them
> after replaying the journal.
>

I guess that should work.
I wonder why the ERROR_FS flag is not snapshotted on mount
and the file system relies on the journal abort flag to re-set the ERRO=
R_FS.

> I wonder if the a better solution for this
> particular use case is much larger ring buffer, and a hook into the
> printk system which is guaranteed to record *everything*, even after =
a
> panic or after the journal has been aborted and the file system has
> been remounted read-only.
>

sounds like a good feature which would be hard to implement...
BTW, I think that if the file system error behavior is set to "remount-=
ro"
a file system with ERROR_FS, should be remounted read-only on mount tim=
e.
this is the only way to prevent a file system from getting over corrupt=
ed
and I don't see why there is no way to enforce this with existing
error behavior options.
We've implemented this logic at application level in our appliances.

> For the patch I wrote, my intention was as a supplement to
> /var/log/messages --- where s_first_error_time might be from long
> after /var/log/messages had rolled over. =A0So I was trying to solve =
a
> somewhat different problem. =A0(Hmm, actually, it would probably be g=
ood
> to save both details about the first as well as the most recent error=
=2E)
>

One thing that is missing from the error info is its severity level.
If I would have to save just one error info, it would be the first
error after fsck
(i.e. transition from healthy to sick file system), but I would
override it if a message
of higher severity occurs.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
