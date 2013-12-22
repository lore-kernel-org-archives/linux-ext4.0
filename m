From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] procfs: Add function to lookup a subdirectory name
Date: Sat, 21 Dec 2013 20:20:09 -0500
Message-ID: <20131222012009.GA27304@thunk.org>
References: <1387580357-28440-1-git-send-email-abbas_raza@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
To: Abbas Raza <abbas_raza@mentor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42312 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3LVBUP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Dec 2013 20:20:15 -0500
Content-Disposition: inline
In-Reply-To: <1387580357-28440-1-git-send-email-abbas_raza@mentor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 21, 2013 at 03:59:16AM +0500, Abbas Raza wrote:
>  /*
> + * Lookup if a subdirectory is present in the given directory by name
> + */
> +int proc_lookup_subdir_by_name(struct proc_dir_entry *dir, const char *name)
> +{

I'm not sure this is the best way to solve the problem you are trying
to get at in patch 2/2.  First of all, this solution is fundamentally
racy; the moment you release proc_subdir_lock, there's always a chance
that some other process will come in and create the proc file in the
subdirectory.  Sure, it's not likely in the case of the ext4 use case,
but as a generic function to be added to fs/proc/generic.c, I suspent
Al is going to NACK this.

Secondly, there is a bigger problem that this is papering over, which
is we don't have a good way of dealing with an unclean eject.  If the
the system was in the middle of reading or writing to the file system
at the time of the unclean eject, there will be all sorts of warnings
and file system errors that will be logged.  That's because we don't
have a way for the block device layer to let the file system know that
the block device has disappeared, and we need to revoke open file
descriptors, and accept the fact that any dirty pages in the cache
cache need to be deleted, lest it clog the system memory forever.

Given the larger problem, I have to admit it's hard for me to get
excited about trying to suppress this particular warning message.  If
we are going to do this, it may be better to simply add a new
proc_mkdir_flags() interface which extends proc_mkdir_data() with a
new integer flags parameter, for which we define a new flag, which
suppresses the warning.

Regards,

					- Ted
