From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A doubt on journal_async_commit option
Date: Fri, 12 Dec 2014 09:54:43 -0500
Message-ID: <20141212145443.GB17783@thunk.org>
References: <548A8534.1050606@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Joseph Qi <joseph.qi@huawei.com>
To: alex chen <alex.chen@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53125 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaLLOyv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Dec 2014 09:54:51 -0500
Content-Disposition: inline
In-Reply-To: <548A8534.1050606@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 12, 2014 at 02:03:32PM +0800, alex chen wrote:
> This commit 0e3d2a6313(ext4: Fix async commit mode to be safe by using
> a barrier) show that using journal_async_commit feature has a 50%
> performance improvement. But I tested in SUSE Linux Enterprise Server
> 11 SP3(linux kernel 3.0.93) and Red Hat Enterprise linux 6.4(linux
> kernel 2.6.32), the result show this feature has no performance
> improvement.
> My test command:
> mount /dev/sdb /mnt/sdb
> ./fs_mark  -d  /mnt/sdb/  -s  10240  -n  1000
> umount
> 
> mount /dev/sdb /mnt/sdb -o journal_async_commit
> ./fs_mark  -d  /mnt/sdb/  -s  10240  -n  1000
> umount
> 
> My test result:
> FSUse%        Count         Size    Files/sec     App Overhead
>      6         1000        10240         42.1            10671
> vs.
> -o journal_async_commit
> FSUse%        Count         Size    Files/sec     App Overhead
>      6         1000        10240         63.9            10625

Um, the files per second went up from 42.1 to 63.9 --- that's a 50%
improvement, yes?

							- Ted
