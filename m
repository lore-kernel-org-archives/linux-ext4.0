From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Tue, 1 Sep 2009 23:05:19 -0700
Message-ID: <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>
References: <4A9D9574.3010606@redhat.com>
	 <20090902055953.GF4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:36530 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZIBGM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 02:12:28 -0400
Received: by pxi42 with SMTP id 42so616781pxi.20
        for <linux-ext4@vger.kernel.org>; Tue, 01 Sep 2009 23:12:30 -0700 (PDT)
In-Reply-To: <20090902055953.GF4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 1, 2009 at 10:59 PM, Andreas Dilger<adilger@sun.com> wrote:
> On Sep 01, 2009 =A016:43 -0500, Eric Sandeen wrote:
>> ext2fs_open2() was only looking at s_blocks_count, and
>> when it wrapped to a low number, it was failing the test of:
>>
>> =A0 fs->super->s_first_data_block >=3D fs->super->s_blocks_count
>>
>> which made the superblock look corrupt.
>
> Is this the source of the "e2fsck is finding bad checksums" problem?

I applied this earlier today, and it didn't appear to help in my test c=
ase.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
