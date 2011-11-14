From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: Add extended option to select quota type
Date: Mon, 14 Nov 2011 10:57:55 -0500
Message-ID: <20111114155755.GC7698@thunk.org>
References: <1320365913-25857-1-git-send-email-adityakali@google.com>
 <1320365913-25857-3-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso.mit.edu@google.com, niu@whamcloud.com,
	linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38436 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1KNP56 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:57:58 -0500
Content-Disposition: inline
In-Reply-To: <1320365913-25857-3-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2011 at 05:18:33PM -0700, Aditya Kali wrote:
> mke2fs was creating both user and group quota inodes on enabling
> the quota feature. This patch adds the extended option 'quotatype'
> that can be used to exclusively specify the quota type that the
> user wants to initialize.
> 
>  # Ex: Default behavior without extended option creates both
>  # user and group quota inodes:
>  $ mke2fs -t ext4 -O quota /dev/ram1
> 
>  # To enable only user quotas:
>  $ mke2fs -t ext4 -O quota -E quotatype=usr /dev/ram1
>  # To enable only group quotas:
>  $ mke2fs -t ext4 -O quota -E quotatype=grp /dev/ram1
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Thanks, applied.

					- Ted
