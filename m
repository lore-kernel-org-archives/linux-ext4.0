From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Thu, 28 Jul 2011 03:08:26 +0900 (JST)
Message-ID: <296456.55216.qm@web4205.mail.ogk.yahoo.co.jp>
References: <134141.91415.qm@web4210.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Robinjp Round <roundrobinjp@yahoo.co.jp>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <aedilger@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4205.mail.ogk.yahoo.co.jp ([124.83.212.25]:36595 "HELO
	web4205.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752337Ab1G0SIa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 14:08:30 -0400
In-Reply-To: <134141.91415.qm@web4210.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have got some nice ideas from you.
I summarize them here and add some comments.

o  Idea from Andreas
    Create minimal image, flash write, then resize2fs

    -> Very straight forward idea.
    -> Post-processing after flash writing adds some difficulties.

o  Idea from Ted
    Zero-fill the non-used blocks.
    Make the flash writer write only non-zero blocks.

    -> Very straight forward idea.
    -> Flash writer needs to support this.

o  Idea from Amir
    Set flex_bg to 32.
    Set sparse_super.
    Allocate journal from group 0 (feasibility unclear)
    Truncate the image.

    -> Feasibility and effectiveness is unclear.
    -> Good side is legacy flash writer can be used.

o  Idea from Yongqiang
    Delete journal before flash write and later add it back.

    -> Post-processing after flash writing adds some difficulties.

I will examine all of these to find out a suitable solution.
Thanks
Round
