From: Pedro Fonseca <pfonseca@mpi-sws.org>
Subject: Re: Data races in ext4
Date: Fri, 11 Apr 2014 15:08:00 +0200
Message-ID: <5347E930.1040601@mpi-sws.org>
References: <53446306.7020005@mpi-sws.org> <20140409213340.GB15303@thunk.org> <5346BB86.50001@mpi-sws.org> <20140410220937.GC31614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from infao0809.mpi-klsb.mpg.de ([139.19.1.49]:42111 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaDKNIG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 09:08:06 -0400
In-Reply-To: <20140410220937.GC31614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> Regarding the generic_fillattr() function, apart from the inconsistency
>> between i_blocks/i_size, it looks like it can also cause wrong values to be
>> returned because several of those fields are 64 bits.
> Well, it's actually a 32-bit seconds and 32-bit nanoseconds field.  So
> we could theoretically get a torn value, but if the ns field is from a
> previous update, the worst that could happen under those circumstances
> is that two quick successive stat() commands could potentially result
> in end up with an apparent "time moving backwards" in the nanoseconds
> field.  If someone was constantly calling utimes(2) to modify the
> mtime/atime at high rate, that might cause a more serious wrong value,
> but that's an argument you should take up with the generic VFS folks
> as to whether it's important enough that they would want to care about
> it.

Note that the races in stat() also involve the "inode->i_blocks" field, 
which is also 64-bits. So, as far as I understand, this field too can 
get wrapped, although it should only affect very large files. (On the 
other hand, the field inode->i_size seems to be protected.)

I'll follow your suggestion and let the VFS developers know about this.


> P.S.  What did you use to generate these reports?  Is it something
> that can be easily replicated by others?

We're currently developing an experimental tool to test the kernel for 
concurrency bugs. It's not yet publicly available, but we hope it will 
become available at some point in the future.

Thanks,
Pedro
