From: Mark Ballard <markjballard@googlemail.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Mon, 18 Aug 2014 21:23:41 +0100
Message-ID: <CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>
	<53F247D5.4030502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62395 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaHRUXm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2014 16:23:42 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf12so6383579vcb.15
        for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2014 13:23:41 -0700 (PDT)
In-Reply-To: <53F247D5.4030502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm guessing that it's the encryption getting in your way.

Cheers, Eric. Does rather look that way. But for the sake of a user report...

>
> How is /dev/sdb1 encrypted?  Usually this is done with something like dm-crypt.
> Or is it hardware encryption managed in the bios?  Did you unlock it?

Done with crytpsetup using luks.

>
> What does "blkid /dev/sdb1" say?
>

It says Luks.
