From: "PaX Team" <pageexec@freemail.hu>
Subject: Re: PAX: size overflow detected in function ext4_llseek fs/ext4/file.c:670
Date: Sat, 13 May 2017 08:56:36 +0200
Message-ID: <5916AE24.5257.4AF94ED1@pageexec.freemail.hu>
References: <CABniQZMSW6DiSvJ7Y2TZTwUKX6sGH6-WkQRjL-kPOmdm7PnKHA@mail.gmail.com>, <5915875E.15260.4679D7CA@pageexec.freemail.hu>, <81b23073-00e7-9cd0-71e3-b9c085a2ac34@gmail.com>
Reply-To: pageexec@freemail.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Brad Spengler <spender@grsecurity.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Emese Revfy <re.emese@gmail.com>,
        Shawn C <citypw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from r00tworld.com ([212.85.137.150]:52656 "EHLO r00tworld.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdEMG4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 May 2017 02:56:44 -0400
In-reply-to: <81b23073-00e7-9cd0-71e3-b9c085a2ac34@gmail.com>
Content-description: Mail message body
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13 May 2017 at 12:23, Shawn C wrote:
> On 05/12/2017 05:58 PM, PaX Team wrote:
> > Shawn, can you do the printk instrumentation i suggested to print out
> > the value of offset (and isize too while at it)?
> >
> I inserted the printk info in fs/ext4/file.c:677
> 
> 00------------------
>         printk(KERN_DEBUG"offset: %lld, isize: %lld, blkbits: %d\n",
> offset, isize, blkbits);
> 11------------------
> 
> result:
> 
> offset: 105, isize: 19595264, blkbits: 12

are you sure this is the last message before the size overflow report?
can you perhaps post the relevant portion of dmesg too?
