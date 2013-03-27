From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Wed, 27 Mar 2013 11:33:23 +0800
Message-ID: <20130327033322.GB9887@gmail.com>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42728 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3C0DRl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2013 23:17:41 -0400
Received: by mail-pa0-f53.google.com with SMTP id bh4so1713949pad.12
        for <linux-ext4@vger.kernel.org>; Tue, 26 Mar 2013 20:17:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <nsxhajyzu6n.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 12:00:48AM -0400, Theodore Ts'o wrote:
> 
> Eric Whitney has very thoughtfully provided an updated set of ext4
> scalability data (with comparisons against ext3, xfs, and btrfs)
> comparing performance between 3.1 and 3.2, and comparing performance
> between 3.2 and 3.6-rc3.
> 
> I've made his compressed tar file available at:
> 
> https://www.kernel.org/pub/linux/kernel/people/tytso/ext4_scaling_data.tar.xz
> https://www.kernel.org/pub/linux/kernel/people/tytso/ext4_scaling_data.tar.gz
> 
> His comments on this data are:
> 
>    It contains two sets of data - one comparing 3.2 and 3.1 (this was
>    the last data set I posted publicly) and another comparing 3.6-rc3
>    and 3.2.  3.6-rc3 was the last data set I collected, and until now, I
>    hadn't prepared graphs for it.  The graphical results are consistent
>    with what I'd reported verbally over the first 2/3 of last year - not
>    much change between 3.2 and 3.6-rc3.  The last large change I could
>    see occurred in 3.2, as mentioned in the notes.
> 
>    The tarball unpacks into a directory named ext4_scaling_data and
>    contains a few subdirectories.  The directories named 3.2 and 3.6-rc3
>    map to the data sets described above.  Each contains a file named
>    index.html which you can open with a web browser to see the graphs,
>    browse the raw data, ffsb profiles and lockstats, etc.
> 
>    Hopefully you'll find the lockstats and other information useful,
>    even though stale (3.6-rc3 became available the last week in August
>    2012).
> 
> Thanks, Eric for making this data available!

Thanks for sharing this with us.  I have an rough idea that we can create
a project, which have some test cases to test the performance of file
system.  We can use fio to simulate all kinds of scenarios, such as

 - logger app (buffered io, append write, sequential write);
 - distribute file system (preallocate, buffered io, random read/write)
 - database (direct io, random read/write)
 - search (mmapped, random read, periodic append write)
 - ...

If we want to measure the performance of file system, we could simply
run a script to run some cases and get some result.

Currently we already have xfstests, but AFAIK it can verify that there
is no bug, deadlock, etc. in a file system, and it couldn't tell us
whether there has a performance regression after applied some patches.
(Please correct me if I am wrong.)  So the question is whether it is
worth creating a new project.  Or we should add these test cases into
xfstests.

Regards,
                                                - Zheng
