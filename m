From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Sun, 27 Feb 2011 20:45:48 -0500
Message-ID: <20110228014548.GO2924@thunk.org>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
 <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca>
 <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
 <AANLkTim0XZe2=3AWw4Ydb8F7BQGCf+=FyjKoyadc+3yw@mail.gmail.com>
 <20110207232343.GA26289@thunk.org>
 <AANLkTikj9qdFJfD+c09V9duTPq_soRv_UsuBgutRHEQt@mail.gmail.com>
 <AANLkTimUhDQAcacCf8gyLn76k+RgRNs52AJbbMmpaaox@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45345 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1B1Bp4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Feb 2011 20:45:56 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimUhDQAcacCf8gyLn76k+RgRNs52AJbbMmpaaox@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 01:35:05PM -0800, Manish Katiyar wrote:
> 
> Is there anything else that I need to do to get this merged in your tree ?
> 

I've added the patch with the following explanation:

ext4: fix missing iput of root inode for some mount error paths

This assures that the root inode is not leaked, and that sb->s_root is
NULL, which will prevent generic_shutdown_super() from doing extra
work, including call sync_filesystem, which ultimately results in
ext4_sync_fs() getting called with an uninitialized struct super,
which is the cause of the crash noted in Kernel Bugzilla #26752.

https://bugzilla.kernel.org/show_bug.cgi?id=26752

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


Sorry for the delay, but this patch was held up pending my tracingg
through the code and understanding why this really fixed BZ #26752.
In the future, adding a bit more detail in the commit log will help me
process the patch faster, since I won't have to reproduce your
analysis.

Also, just quoting a BZ number without going into more detail risks my
putting it the patch on my "to analyze --- when I have access to
network" queue if I happen to come across it while on an airplane.  :-)

					- Ted
