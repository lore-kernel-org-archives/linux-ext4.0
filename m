From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: don't remove reserved inodes in ext4_unlink()
Date: Fri, 14 Feb 2014 13:04:29 +0800
Message-ID: <20140214050429.GB12822@dhcp-13-216.nay.redhat.com>
References: <1390633097-16194-1-git-send-email-guaneryu@gmail.com>
 <20140212163825.GE14520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48765 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaBNFEe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Feb 2014 00:04:34 -0500
Received: by mail-pd0-f172.google.com with SMTP id p10so11455148pdj.17
        for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 21:04:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140212163825.GE14520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 12, 2014 at 11:38:25AM -0500, Theodore Ts'o wrote:
> On Sat, Jan 25, 2014 at 02:58:17PM +0800, Eryu Guan wrote:
> > Corrupted ext4_dir_entry_2 struct on disk may have wrong inode number,
> > when the inode number is 8 (EXT4_JOURNAL_INO) and the file is deleted,
> > the journal inode is gone, and unmounting such a fs could trigger the
> > following BUG_ON() in start_this_handle().....
> 
> This patch is mostly good, but you need to exempt the root inode.
> Otherwise, the following program, which would normally give the error
> "unlink: Is a directory", will mark the file system as containing an
> error, and so it could allow an unprivileged user to remount the file
> system read-only, or force the system to panic and reboot.

Hi Ted,

I dont' see how the following program could mark the file system as
containing an error on patched kernel. I tried running it on both
patched/unpatched kernel, and it gave "unlink: Is a directory" in both
cases. And dumpe2fs -h didn't show that fs contained errors.

I traced do_unlinkat(), vfs_unlink() and ext4_unlink() in systemtap
and systemtap showed only do_unlinkat() was being called.

Am I missing something here?

Thanks,
Eryu
> 
> #include <unistd.h>
> 
> int main(int argc, char **argv)
> {
> 
> 	if (unlink("/") < 0)
> 		perror("unlink");
> 	return 0;
> }
> 
> Cheers,
> 
> 					- Ted
