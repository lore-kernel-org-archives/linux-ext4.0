From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 10 Aug 2011 01:05:29 +0900 (JST)
Message-ID: <20110809160534.88984.qmail@web4207.mail.ogk.yahoo.co.jp>
References: <CAOQ4uxjaAmJ6acCBNUtKW2th-+k8vXfdX7gsb-W_sFvj10-rXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Dilger Andreas <aedilger@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Goldstein Amir <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4207.mail.ogk.yahoo.co.jp ([124.83.212.27]:25681 "HELO
	web4207.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752673Ab1HIQFg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Aug 2011 12:05:36 -0400
In-Reply-To: <CAOQ4uxjaAmJ6acCBNUtKW2th-+k8vXfdX7gsb-W_sFvj10-rXg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Amir

> https://raw.github.com/amir73il/e2fsprogs-snapshots/next4-stable/contrib/uninit_bg.c
> 
> amir@qalab:~$ gcc -o uninit_bg -lext2fs uninit_bg.c

For me, it gives error:

$ gcc -o uninit_bg -lext2fs uninit_bg.c
uninit_bg.c: In function ‘main’:
uninit_bg.c:105:2: error: invalid use of undefined type ‘struct opaque_ext2_group_desc’
uninit_bg.c:105:5: warning: assignment from incompatible pointer type
$

I have the latest source code from
git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
but nowhere I can find the full declaration of
struct opaque_ext2_group_desc.

Am I missing something?
I didn't want to bother you for this, but I could not
solve the puzzle.

Thanks
Round
