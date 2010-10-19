From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Committing changes to an ext3_inode structure
Date: Tue, 19 Oct 2010 18:55:37 -0400
Message-ID: <AANLkTinZB5Qv1H-Dt0CQgVFF2_W85NwEdJN3M7nOw-Qo@mail.gmail.com>
References: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org> <B25FFA22-5EBF-472C-B030-22617E4539DE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe Franciosi <felipe@paradoxo.org>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63982 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0JSWz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 18:55:58 -0400
Received: by gwb10 with SMTP id 10so21269gwb.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Oct 2010 15:55:58 -0700 (PDT)
In-Reply-To: <B25FFA22-5EBF-472C-B030-22617E4539DE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 19, 2010 at 5:56 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2010-10-19, at 09:23, Felipe Franciosi wrote:
>> I am experimenting on a 2.6.20.3-ubuntu1 kernel to prototype and eva=
luate different methods for migrating datablocks for a given inode on t=
he fly.
>>
>> I have created an ioctl call that implements some verifications and =
invokes a function I wrote in balloc.c for such migration.
>
> Are you aware that there already is the ability to do on-the-fly migr=
ation of files in ext4? =A0This was developed quite some time ago and i=
s in ext4 in newer kernels (not sure of the exact version, maybe 2.6.32=
 or so).
>
> I would strongly recommend that you investigate that code, since it c=
ould definitely use some good testing/inspection/enhancement (as needed=
). =A0It is in fs/ext4/migrate.c, though I'm not sure where the user-sp=
ace tools are located (maybe e2fsprogs?).
>
> Cheers, Andreas

I'm not familiar with that code, I'm curious what it does?

But there is also the EXT4_IOC_MOVE_EXT ioctl which is called by
e4defrag primarily.

The code is in fs/ext4/move_extent.c

The concept is you allocate new blocks in a donor inode.  Once you
have that done, then EXT4_IOC_MOVE_EXT will move the data from the
original data blocks to the new ones and replace the old original
blocks with the new donor blocks.

All done on the fly.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
