From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] Fix EXT4_FEATURE_RO_COMPAT_HUGE_FILE check
Date: Tue, 24 Aug 2010 12:32:12 -0700
Message-ID: <AANLkTi=XH3R4Tzq=5zXRUUTxTo533HT5=tpwQ1xMs7uU@mail.gmail.com>
References: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com>
	<426FFD16-98B3-4427-BDA5-C80CE184781C@dilger.ca>
	<4C73F627.2000809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33289 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXTcN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Aug 2010 15:32:13 -0400
Received: by vws3 with SMTP id 3so791540vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 Aug 2010 12:32:13 -0700 (PDT)
In-Reply-To: <4C73F627.2000809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 24, 2010 at 9:41 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> Andreas Dilger wrote:
>
>> This isn't the first time that we've had problems like this, and it
>> won't be the last time unless there is a better API for checking
>> these flags.
>
> *nod*
>

On a related note (to my original problem)... is the bad i_blocks
count fixup code in the check_blocks() function of pass1.c broken for
large files, or am I misunderstanding the code?  pb.num_blocks and
ext2fs_inode_i_blocks() are both >32 bits, but the fixup code appears
to always try to shove pb.num_blocks into the 32-bit inode->i_blocks
and set inode->osd2.linux2.l_i_blocks_hi = 0.

-Justin
