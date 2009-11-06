From: Alexey Salmin <alexey.salmin@gmail.com>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 6 Nov 2009 17:57:14 +0600
Message-ID: <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com>
References: <4AF3F82D.50105@elector.dk> <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>
	<4AF40D60.1080503@elector.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jesper Jensen <linux-ext4_mailinglist@elector.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54165 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZKFL5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 06:57:31 -0500
Received: by bwz27 with SMTP id 27so1061400bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 06 Nov 2009 03:57:36 -0800 (PST)
In-Reply-To: <4AF40D60.1080503@elector.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think the only thing I can recommend to you is to "grep for your
files and hope for the best" (c)
I don't know any automated way to restore files after complete
destroying of fs, but there always is grep and hexdump :)

On Fri, Nov 6, 2009 at 5:49 PM, Jesper Jensen
<linux-ext4_mailinglist@elector.dk> wrote:
> Well, I did a mkfs, so as far as I haven't erased the entire content =
of the
> disk.
>
> Maybe I should mention that the ext4 partition in question is running=
 on
> inside a ESXi with the physical disk formattet to VMFS and mounted in=
 my
> virtual machine (Ubuntu).
>
> It was the physical disk that got formatted by ESXi and I then recrea=
ted the
> virtual disk and made a new ext4 filesystem on top of that.
>
> A bit complicated yea, hence why I accidentally used the wrong disk. =
:-(
>
>
> Regards
> Jesper
>
> Alexey Salmin wrote:
>>
>> Have you only repartitioned your disk or also formatted it?
>
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
