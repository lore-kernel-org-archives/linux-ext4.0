From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 18:09:03 +0200
Message-ID: <CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
	<CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
	<20130715134357.GA26359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53892 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab3GOQJE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jul 2013 12:09:04 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so10939877pdj.0
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 09:09:03 -0700 (PDT)
In-Reply-To: <20130715134357.GA26359@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Thanks. Now I think that I am getting closer to something more concrete.

My superblock says:

superblock^.s_blocks_per_group = 32768
superblock^.s_inodes_per_group = 8080
superblock^.s_log_block_size = 2 -> so each block has 4k bytes

And when reading the root "/"  I obtain the following information for
the directory /bin/ : inode=8081

So I calculate that it should have:
groupnr=1 (because it is above 8080 inodes per group)
offset for groupnr 1 --> 4k * 32768 = 0x8000000

But I have utilized a hex editor (oh boy, it was hard to find one that
would read files over 4GB....) And the directory listing of /bin/ is
located in aprox. near 0x21B0000

As if each block group would have a size of 0x2000000 .... but this
size would be valid I would expect if
superblock^.s_blocks_per_group=8192 ...

Any idea what I missed here that the calculations went wrong?

thanks,
-- 
Felipe Monteiro de Carvalho
