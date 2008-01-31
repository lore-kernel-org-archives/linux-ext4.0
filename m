From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Thu, 31 Jan 2008 16:42:07 +0100
Message-ID: <20080131154207.GA22201@alice>
References: <20080131140137.GA20780@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751812AbYAaPmJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 10:42:09 -0500
Content-Disposition: inline
In-Reply-To: <20080131140137.GA20780@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> hi,
> 
> while running a modified version of fsfuzzer i triggered the BUG() in
> ext4_mb_release_inode_pa(). Sadly I am not able to reproduce this using
> the generated image, but running the fuzzer will usually trigger this in
> less than 40 attempts. Increasing the JBD2 Debug level didnt give more
> information. The kernel is current git with
> ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch
> applied. 

I am now able to reproduce this using this image:
http://www.cccmz.de/~snakebyte/ext4.24.img.bz2

the following commands will trigger the oops for me

mount cfs/ext4.24.img /media/test -t ext4dev -o extents -o loop
mkdir /media/test/stress
chown snakebyte:snakebyte /media/test/stress && sudo -u snakebyte fstest -n 10 -l 10 -f 5 -s 40000 -p /media/test/stress/


The && between the chown and fstest seems necessary

Greetings, Eric
