From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 scaling limits ?
Date: Tue, 21 Mar 2017 17:48:11 -0400
Message-ID: <32A4A230-566F-4476-A516-2C6C4BA5C1C6@dilger.ca>
References: <CAE0An6fc6tX6ACQYdTYdP+CwN=RDKuv_oaW0xeNrBLY_1AvOtw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34649 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756845AbdCUVsN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2017 17:48:13 -0400
Received: by mail-qk0-f169.google.com with SMTP id p64so145765559qke.1
        for <linux-ext4@vger.kernel.org>; Tue, 21 Mar 2017 14:48:12 -0700 (PDT)
In-Reply-To: <CAE0An6fc6tX6ACQYdTYdP+CwN=RDKuv_oaW0xeNrBLY_1AvOtw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While it is true that e2fsck does not free memory during operation, in
practice this is not a problem. Even for large filesystems (say 32-48TB)
it will only use around 8-12GB of RAM so that is very reasonable for a
server today. 

The rough estimate that I use for e2fsck is 1 byte of RAM per block. 

Cheers, Andreas

> On Mar 21, 2017, at 16:07, Manish Katiyar <mkatiyar@gmail.com> wrote:
> 
> Hi,
> 
> I was looking at e2fsck code to see if there are any limits on running
> e2fsck on large ext4 filesystems. From the code it looks like all the
> required metadata while e2fsck is running is only kept in memory and
> is only flushed to disk when the appropriate changes are corrected.
> (Except the undo file case).
> There doesn't seem to be a case/code where we have to periodically
> flush some tracking metadata while it is running, just because we have
> too much of incore tracking data and may ran out of memory (looks like
> code will simply return failure if ext2fs_get_mem() returns failure)
> 
> Appreciate if someone can confirm that my understanding is correct ?
> 
> Thanks -
> Manish
