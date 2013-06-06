From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 43/52] fs/ext4/inode.c:2211:6: warning: 'err' may be
 used uninitialized in this function
Date: Thu, 6 Jun 2013 10:57:11 -0400
Message-ID: <20130606145711.GC5382@thunk.org>
References: <51aed48d.xK+2xHaWtYVlAT8d%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, kbuild-all@01.org, sfr@canb.auug.org.au,
	linux-ext4@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3FFO5S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jun 2013 10:57:18 -0400
Content-Disposition: inline
In-Reply-To: <51aed48d.xK+2xHaWtYVlAT8d%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 05, 2013 at 02:02:53PM +0800, kbuild test robot wrote:
> All warnings:
> 
>    fs/ext4/inode.c: In function 'ext4_da_writepages':
> >> fs/ext4/inode.c:2211:6: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    fs/ext4/inode.c:2154:6: note: 'err' was declared here

This looks like a false warning.  mpage_map_and_submit_extent() is
only capped when mpd.m_len is non-zero.  Hence we will execute the
budy of the while loop in that function at least once, which means err
will be initialized.

I'm curious what gcc version and/or -Wall flags triggered this
warning.  I'm using gcc 4.7.2 from Debian and it's not complaining.

I'm happy to initialize err to zero just to shut up the gcc warning,
but I'm curious how often it's triggered, since this looked pretty
trivial for gcc to be able to figure out on its own.

Thanks,

						- Ted
