From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: handle errors in ext4_clear_blocks()
Date: Sun, 20 Mar 2011 21:37:49 -0400
Message-ID: <20110321013749.GE4135@thunk.org>
References: <AANLkTi=zteq96AQ54f3qo29dRGCmMhwtR4BzKPXQLt0W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48778 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab1CUBhx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2011 21:37:53 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=zteq96AQ54f3qo29dRGCmMhwtR4BzKPXQLt0W@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 01, 2011 at 02:28:26PM +0200, Amir Goldstein wrote:
> +out_err:
> +	ext4_std_error(inode->i_sb, err);
> +	return err;

Umm, you do realize this function will mark the file system as dirty,
and possibly remount the file system read-only, or panic the system,
right?

That's appropriate for normal journal failures (since there's no
recovering from them), but if you're proposing that a simple lack of
free blocks when doing a COW operation will result in a ENOSPC, all a
malicious userspace application needs to do to potentially bring the
system down is to attempt to unlink or truncate a file while COW
snapshots are enabled.....

Do you really want me to include this patch?  I think you may want to
rethink how you want to handle this case....

						- Ted
