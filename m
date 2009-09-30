From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/3] e4defrag: output blocks per extent by -c option
Date: Wed, 30 Sep 2009 14:28:12 -0400
Message-ID: <87f94c370909301128w4bfe6f4bh80bf3d6540ed83d3@mail.gmail.com>
References: <4AC306B0.9070308@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:35988 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZI3S2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 14:28:09 -0400
Received: by yxe37 with SMTP id 37so7058473yxe.33
        for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 11:28:13 -0700 (PDT)
In-Reply-To: <4AC306B0.9070308@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/9/30 Kazuya Mio <k-mio@sx.jp.nec.com>:
> e4defrag with -c option outputs "ratio" that means the levels of
> fragmentation. However, it's difficult for users to understand, so we=
 will
> use blocks per extent instead of ratio.
>
> Before:
> # e4defrag -c /mnt/mp1/file
> <File> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 now/best =A0 =A0 =A0 =A0 =A0ratio
> /mnt/mp1/file =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 14/1 =A0 =A0 =A0 =A0 =A0 =A0 0.01%
>
> =A0Total/best extents =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 14/1
> =A0Fragmentation ratio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00.01%
> =A0Fragmentation score =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00.10
> =A0[0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
> =A0This file(/mnt/mp1/file) does not need defragmentation.
> =A0Done.
>
> After:
> # e4defrag -c /mnt/mp1/file
> <File> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 now/best =A0 =A0 =A0 =A0blk/ext
> /mnt/mp1/file =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 14/1 =A0 =A0 =A0 =A0 =A0 =A0 =A07142
>
> =A0Total/best extents =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 14/1
> =A0Average blocks per extent =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A07142
> =A0Fragmentation score =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00
> =A0[0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
> =A0This file(/mnt/mp1/file) does not need defragmentation.
> =A0Done.

RFC

If we are going go that far (which I like), how about adding the avg
extent size in bytes.  (ie. 7142 * blocksize I assume).

Also a note about the max blocks / extent might be good.

ie. Add a more or less hard coded line
Ext4 max blocks per extent     32,768  (128MiB)

Otherwise your typical user won't know what perfect is.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
