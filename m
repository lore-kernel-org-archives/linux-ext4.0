From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: Problems with e4defrag -c
Date: Wed, 19 Jan 2011 17:17:39 +0900
Message-ID: <4D369E23.3010703@sx.jp.nec.com>
References: <E1PWFc1-0002cm-QV@tytso-glaptop> <4D256E18.3010708@sx.jp.nec.com> <20110107193810.GP21922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33007 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1ASITn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jan 2011 03:19:43 -0500
In-Reply-To: <20110107193810.GP21922@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/01/08 4:38, Ted Ts'o wrote:
> If we do it that way, I'm not sure we really need to have access to
> the superblock to get various file system values. I can imagine requesting
> certain parameters --- if you have root access, you can grab the superblock
> and adjust the "threshold of perfection" down from 256MB to 32MB
> if flex_bg is not enabled, or based on the size of the flex_bg groups. But if
> you don't have access, it might be smarter just to use some default
> "threshold of perfection", as opposed to having lots of "do we have root"
> checks sprinkled all over the program.

I agree to use some default "threshold of perfection". In this case, 256MB is
too big because all files will get the worst score if flex_bg is disabled.
So I think "blocks_per_group - 2048" seems to be good threshold. 2048 means
the maximum block region of mballoc with the exception of more than
8KB blocksize. If we try to allocate the contiguous blocks including some
metadata blocks (backup of the superblock, blockgroup descriptor, etc.),
this threshold will judge that there is no fragmentation in the file.

e.g. Allocate 512MB contiguous blocks including some metadata blocks

# dd if=/dev/zero of=/mnt/mp1/file bs=1M count=512 oflag=sync
# filefrag -v /mnt/mp1/file
Filesystem type is: ef53
File size of /mnt/mp1/file is 536870912 (131072 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0    33280           30720
    1   30720    65536    63999  32768
    2   63488   100352    98303  32768
    3   96256   133120           30720
    4  126976   165888   163839   4096 eof

> Hmm, maybe the right answer is that we have a single function, located
> in libe2p, that calculates the "fragmentation score". We can separate that
> out from the e4defrag code, and make it be a library function. The programs
> that want to use it can call that library function. (Parameters to the
> fragmentation score, such as the "threshold of perfection", would be passed
> into the library function, along with a file descriptor to the file so that
> FIEMAP could be called on that file.)

OK. I'll create the new file "fragment_score.c" into lib/e2p and add
a function to this file. We can get the percent of the small extents in the
target file by calling this function.

> I'm not sure how useful it is to do a recursive tree walk just to display
> the information for all the files in the directory. Filefrag will already
> take a list of files on the command-line, and if you want to do a recursive
> tree walk, you can do a "find /path/to/dir -type f | xargs filefrag".

It's true that we should use find command if we really want to know
the fragmentation scores of all of the files in the directory.
I won't add a recursive tree walk to filefrag.

Regards,
Kazuya Mio
