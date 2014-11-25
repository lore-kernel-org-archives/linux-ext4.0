From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH-v3 1/6] fs: split update_time() into update_time() and
 write_time()
Date: Tue, 25 Nov 2014 17:00:18 +0100
Message-ID: <20141125160018.GG26471@twin.jikos.cz>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
 <1416893674-419-2-git-send-email-tytso@mit.edu>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaKYQAT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 11:00:19 -0500
Content-Disposition: inline
In-Reply-To: <1416893674-419-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2014 at 12:34:29AM -0500, Theodore Ts'o wrote:
> In preparation for adding support for the lazytime mount option, we
> need to be able to separate out the update_time() and write_time()
> inode operations.  Currently, only btrfs and xfs uses update_time().
> 
> We needed to preserve update_time() because btrfs wants to have a
> special btrfs_root_readonly() check; otherwise we could drop the
> update_time() inode operation entirely.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: xfs@oss.sgi.com
> Cc: linux-btrfs@vger.kernel.org

For the btrfs changes

Acked-by: David Sterba <dsterba@suse.cz>
