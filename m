From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: File permissions in ext4
Date: Thu, 1 Aug 2013 15:19:55 +0200
Message-ID: <CACyNnZPY8hjJrrjO4US5d-ZFfKA=py2DqgFbHjtKo3xWOHuSRg@mail.gmail.com>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
	<CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
	<1375361980.2304.4.camel@slavad-ubuntu>
	<CACyNnZNdVo73TUhaMsx8j7kZq=M65XEMzwmWCi4M7Js0G0k4TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: slava@dubeyko.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50939 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3HANT4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 09:19:56 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so2113578pad.23
        for <linux-ext4@vger.kernel.org>; Thu, 01 Aug 2013 06:19:55 -0700 (PDT)
In-Reply-To: <CACyNnZNdVo73TUhaMsx8j7kZq=M65XEMzwmWCi4M7Js0G0k4TA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 1, 2013 at 3:09 PM, Felipe Monteiro de Carvalho
<felipemonteiro.carvalho@gmail.com> wrote:
> On Thu, Aug 1, 2013 at 2:59 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
>> Do you build the kernel with POSIX ACLs support
>> (CONFIG_EXT4_FS_POSIX_ACL)?
>
> Anyway to find out this? I am using the pre-compiled kernel which
> comes with Mageia Linux ... so I did not compile the kernel myself.

But anyway, I have my own code for reading the file system which I am
running in Mac OS X/Linux/Windows ... so I wonder what difference it
would make the kernel... maybe it is about the kernel at the time when
the partition was created?

-- 
Felipe Monteiro de Carvalho
