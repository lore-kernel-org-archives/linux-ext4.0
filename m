From: Ted Ts'o <tytso@mit.edu>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 9 May 2011 09:28:18 -0400
Message-ID: <20110509132818.GI4138@thunk.org>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>
 <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
 <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
 <20110509120608.GK4122@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	adilger@dilger.ca, amir73il@users.sourceforge.net
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34470 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1EIN2Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 09:28:24 -0400
Content-Disposition: inline
In-Reply-To: <20110509120608.GK4122@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 09, 2011 at 02:06:08PM +0200, Jan Kara wrote:
>   Yes, that would be reasonable although it might break some people's
> scripts. But probably worth it anyway.

I wouldn't object to a patch to e2fsprogs which changes mke2fs to do
this check and refuses to blow away a file system if:

[defaults]
    check_for_prexisting_fs = true

was in /etc/mke2fs.conf.

I'd also suggest that mke2fs -f NOT enable mke2fs to blow away file
systems, but that we add a new utility --- probably to util-linux-ng
--- with the destroy_partition, which a system administrator has to
explicitly run to blow away a partition.

I'd really rather not train people that mke2fs -f is the way to get
the utility to !@#@! shut up.  It's exactly the same problem with why
"alias rm 'rm -i'" doesn't work.  System administrators just get in
the habit of typing return, 'y', return, and in the end things still
just get lost.

If we have a separate utility, destroy_filesystem, which checks to see
if there is a tty, and if so, prints the details of what is on the
partition, and then forces the user to type "YES<return>", then we
have a unified way of protecting against careless sysadmins.  We can
also have that utility do clever things, such as simply telling the
hard drive to reinitiailize its crypto keys if it supports FDE, or
tell it to TRIM the entire disk if it supports TRIM/DISCARD, etc.

							- Ted
