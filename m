From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: current e2fsprogs maint branch test results
Date: Wed, 18 Dec 2013 13:36:57 -0800
Message-ID: <20131218213657.GA25946@birch.djwong.org>
References: <20131217234313.GA2183@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47972 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab3LRVhG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Dec 2013 16:37:06 -0500
Content-Disposition: inline
In-Reply-To: <20131217234313.GA2183@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 17, 2013 at 06:43:13PM -0500, Eric Whitney wrote:
> I've built the contents of the current e2fsprogs maint branch (4727c67dc2)
> and run make check on both a Pandaboard (ARM) and an x86-64 VM. In each
> case I used the following arguments to configure: --disable-uuidd
> --disable-libuuid --disable-libblkid.
> 
> Both the ARM and x86-64 runs produced warnings when compiling ea_refcount.c
> during make check.  I posted a patch yesterday (e2fsck: fix printf
> conversion specs in ea_refcount.c) that clears those up for me on both
> platforms.
> 
> The ARM build and make check were otherwise clean.
> 
> The x86-64 build and make check contained one more problem - a warning while
> compiling debugfs.c:
> ../../debugfs/debugfs.c:2462:5: warning: too many arguments for format
>  [-Wformat-extra-args]
> 
> This code (commit fe56188b07) is part of that used to check superblock block
> numbers specified on the command line, and the error reporting has become
> a little fuzzy relative to what we had previously.
> 
> Before:
> 
> root@debug1:~# debugfs -s 327b /dev/vdc
> debugfs 1.42.8 (20-Jun-2013)
> debugfs: Bad superblock number - 327b
> 
> After:
> 
> root@debug1:~# debugfs -s 327b /dev/vdc
> debugfs 1.42.8 (20-Jun-2013)
> debugfs: Bad block number - 327b
> debugfs: Invalid block number: 327b
> debugfs: Operation not permitted 
> 
> Both strtoblk() and parseulonglong() (which it calls) output error messages
> for bad/invalid block numbers, which is redundant in this case.  The last
> (erroneous) error message is output by the call to com_err() which also 
> causes the warning noted above.
> 
> It seems to me that the call to com_err() ought to be deleted, and maybe
> the immediately preceding call to strtoblk() ought to be converted to a call
> to parseulonglong() to restore the original messaging.  I'd like to post a
> patch, but there are a number of other calls to strtoblk() in debugfs now
> that will produce two messages on errors, and the intent isn't clear to me.
> Is this just an area that needed a little more polish?

Back in October, I wrote a patch[1] that did a straight conversion to
parse_ulonglong for 64bit support, but Lukas suggested using strtoblk instead.
So I changed it, and that's what's in there now... uglified.  Sorry about that.
I should have argued more strongly against strtoblk. :(

I don't have a problem with changing it to parse_ulonglong.

[1] http://patchwork.ozlabs.org/patch/279295/

--D
