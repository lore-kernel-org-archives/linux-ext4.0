From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 9 Aug 2011 22:55:17 +0300
Message-ID: <CAOQ4uxhJOSmuLcyGt-k09iq5nieyPNFPA-qunGTOE_98VfESPg@mail.gmail.com>
References: <CAOQ4uxjaAmJ6acCBNUtKW2th-+k8vXfdX7gsb-W_sFvj10-rXg@mail.gmail.com>
	<20110809160534.88984.qmail@web4207.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dilger Andreas <aedilger@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40633 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1HITzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Aug 2011 15:55:18 -0400
Received: by wyg24 with SMTP id 24so238909wyg.19
        for <linux-ext4@vger.kernel.org>; Tue, 09 Aug 2011 12:55:17 -0700 (PDT)
In-Reply-To: <20110809160534.88984.qmail@web4207.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/8/9 Round Robinjp <roundrobinjp@yahoo.co.jp>:
> Amir
>
>> https://raw.github.com/amir73il/e2fsprogs-snapshots/next4-stable/con=
trib/uninit_bg.c
>>
>> amir@qalab:~$ gcc -o uninit_bg -lext2fs uninit_bg.c
>
> For me, it gives error:
>
> $ gcc -o uninit_bg -lext2fs uninit_bg.c
> uninit_bg.c: In function =91main=92:
> uninit_bg.c:105:2: error: invalid use of undefined type =91struct opa=
que_ext2_group_desc=92
> uninit_bg.c:105:5: warning: assignment from incompatible pointer type
> $
>
> I have the latest source code from
> git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
> but nowhere I can find the full declaration of
> struct opaque_ext2_group_desc.
>
> Am I missing something?

I did not build this tool with latest e2fsprogs lib, I built it with
stable version 1.41.14
which comes installed with my Ubuntu distro.
Basically, you don't need to download and build any sources, but since
you have built
e2fsprogs from git already you may as well checkout tag v1.41.14,
configure build and install it.
hope this helps.

> I didn't want to bother you for this, but I could not
> solve the puzzle.
>
> Thanks
> Round
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
