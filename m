From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/3] ext4: Use readahead when reading an inode from the
	inode table
Date: Fri, 26 Sep 2008 02:21:07 -0600
Message-ID: <20080926082107.GT10950@webber.adilger.int>
References: <1222275213-16268-1-git-send-email-tytso@mit.edu>
 <1222275213-16268-2-git-send-email-tytso@mit.edu>
 <1222275213-16268-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33767 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYIZIVe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 04:21:34 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8Q8LWQH012122
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 01:21:33 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7S00601N5Z0K00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 01:21:32 -0700 (PDT)
In-reply-to: <1222275213-16268-3-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 24, 2008  12:53 -0400, Theodore Ts'o wrote:
> @@ -514,8 +514,10 @@ static void ext4_put_super(struct super_block *sb)
> +	if (sbi->s_proc) {
> +		remove_proc_entry("inode_readahead_bits", sbi->s_proc);
>  		remove_proc_entry(sb->s_id, ext4_proc_root);

As a general UI interface, specifying the "bits to shift the filesystem
block number" seems like an easy-to-implement but is fairly bad from
a usability point of view.  I'd much prefer to specify this as a
number of kB to readahead, and it can be converted internally to the
number of blocks to readahead.  It isn't fatal if we do a bit of rounding
on the input value to match a full blocksize.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

