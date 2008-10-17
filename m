From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: undelete still opened file
Date: Fri, 17 Oct 2008 16:03:11 +0530
Message-ID: <ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com>
References: <20081017120852.1f04dc36.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "=?ISO-8859-1?Q?Lars_T=E4uber?=" <taeuber@bbaw.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:3444 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYJQKdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 06:33:13 -0400
Received: by ti-out-0910.google.com with SMTP id b6so247709tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 03:33:12 -0700 (PDT)
In-Reply-To: <20081017120852.1f04dc36.taeuber@bbaw.de>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 3:38 PM, Lars T=E4uber <taeuber@bbaw.de> wrote:
> Hi there!
>
> If this should be the wrong mailing list please excuse me but I didn'=
t find any better suiting.
> I just subscribed after unsuccessfully searching on the net for an an=
swer to my question.
>
> Is it possible to undelete an accidentally deleted file that is still=
 opened by a process?
> As far as I know the file is not really deleted as long there is a fi=
le descriptor connected to the file.
> I thought about something in connection with /proc/####/fd/# .
> Is there any chance to get the file back to normal?

To some extent yes......

>
> - Linux 2.6.[12]x
> - ext3 or nfs (should be independent of fs, wouldn't it?)

It is tightly coupled with the filesystem. So depending on your
filesystem you may or may not get it.

LOGFS (or any log structured file system) : They generally have
snapshots or some kind of file versioning. So you can retreive it from
there.

ext2 : After deletion ext2 doesn't zero the block pointers. So it is
possible to get it from there using debugfs.

ext3 : Search google for "Carlo wood + ext3grep"

ext4 : I don't know of any method ...

You can try the /proc/****/fd/** approach . It has worked for me in
past......but that was for a running binary. I am not sure about
shellscript kind of thing. There are some other tools too to recover ,
unfortunately I don't remember the name but google should be good
enough.

Thanks -
Manish



>
>
> Thanks and best regards.
> Lars
>
>
> PS: Sorry for my english.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
