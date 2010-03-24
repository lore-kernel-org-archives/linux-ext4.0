From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Re: ext2/ext3 different block_sizes/i_size/e2fsck question
Date: Thu, 25 Mar 2010 02:18:12 +0300
Message-ID: <e1e08eb01003241618l17744154p943871532e552698@mail.gmail.com>
References: <e1e08eb01003241227p35e84777q622996b861009ecb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:38836 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0CXXSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 19:18:14 -0400
Received: by fxm23 with SMTP id 23so612898fxm.21
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 16:18:12 -0700 (PDT)
In-Reply-To: <e1e08eb01003241227p35e84777q622996b861009ecb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've also noted a very interesting and strange thing. I checked a file
for which e2fsck did 67445000->67446784 i_size change.
debugfs stat comparison between fixed file and file with old size
differs in i_size *only* (all blocks are the same), but cmp shows
difference in 67382273 (it's constant for any bogus file), that is
block 65803 which is the last before triple indirection. How did file
change if e2fsck just had changed i_size and both values are greater
than 67382273?


On Wed, Mar 24, 2010 at 10:27 PM, Evgeniy Ivanov <lolkaantimat@gmail.com> wrote:
> Hello,
>
> Sorry for bothering list with my ext2 questions.
> I got into trouble with my ext2 implementation and filesystem with
> 1024 block size. Sometimes when I write files they're written
> correctly (md5sum is the same as original, i_size is correct either),
> but e2fsck changes i_size to another values (which breaks files). E.g.
> 67445000->67446784 or 67445248->67446784. I see that new sizes are
> numbers of multiples of 1024.
> Strange thing is that I can't reproduce this problem with 2048 and
> 4096 block sizes. I thought the problem was in trash in unused part of
> last block (actually it is zeroed), but then it would be reproduceable
> in fs with another block size.
> How does ext2 decide to fix that files sizes? Any suggestions?
>
> Thanks in advance for any help.
>
>
> --
> Evgeniy Ivanov
>



-- 
Evgeniy Ivanov
