From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: ext over RAID-[56]?
Date: Sun, 17 Oct 2010 12:38:49 +0200
Message-ID: <AANLkTin7fNhmJuX-M8U+bVA_5ymx16MN5zJ8axC1k1Q1@mail.gmail.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D5FE3@wdscexbe08.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37020 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0JQKiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Oct 2010 06:38:54 -0400
Received: by qwa26 with SMTP id 26so1097067qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Oct 2010 03:38:51 -0700 (PDT)
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF20D5FE3@wdscexbe08.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 17, 2010 at 2:16 AM, Daniel Taylor <Daniel.Taylor@wdc.com> =
wrote:
> One of the program managers here asked me a question that I couldn't =
answer:
>
> with ext[34] over a RAID-[56] volume, what protection against data
> corruption
> and loss of existing data does the file system provide for the case o=
f an
> incomplete update of the RAID "stripe"?
>
> I know that anyone with any usable brain cells has their data server =
on a
> nice
> UPS, but not all customers are so equipped, and he's concerned about
> corruption
> during a power failure (loss of unwritten data is OK).
>
> I can't see any configuration options that would help but I could eas=
ily be
> missing something. =A0Any ideas?
>

I don't think you are missing something. check out this article:
http://lwn.net/Articles/349970/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
