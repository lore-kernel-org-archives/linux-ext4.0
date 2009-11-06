From: Alexey Salmin <alexey.salmin@gmail.com>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 6 Nov 2009 16:49:43 +0600
Message-ID: <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>
References: <4AF3F82D.50105@elector.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jesper Jensen <linux-ext4_mailinglist@elector.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35697 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZKFK5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 05:57:09 -0500
Received: by bwz27 with SMTP id 27so1007815bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 06 Nov 2009 02:57:13 -0800 (PST)
In-Reply-To: <4AF3F82D.50105@elector.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Have you only repartitioned your disk or also formatted it?

On Fri, Nov 6, 2009 at 4:19 PM, Jesper Jensen
<linux-ext4_mailinglist@elector.dk> wrote:
> First of all I know this isn't a development or bug related question,=
 but
> I'm running out of ideas on how to rescue my files, so I hope you guy=
s can
> bare with me.
>
> Yesterday I accidentally did a repartition ad and mkfs.ext4 on the wr=
ong
> data disk, ARRGH! I thought it was an empty disk, but nooo it was one
> containing a lot of data that I don't really have a backup of anywher=
e. :-(
>
> I've tried various fsck -f -b <backup superblocks> but it looks like =
I might
> have made a royal fuckup and overwritten/erased every single backup
> superblock. :-(
>
> As far as I recall the first time I ran fsck it said something about =
the
> blocks being empty and asked me to accept a bunch of times (eventuall=
y ended
> up using the -p option).
>
> I have also tried tools like magicrescue and foremost to recover my f=
iles,
> but no such luck.
>
> Can you guys recommend a good way to recover the files?
>
>
> Regards
> Jesper
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
