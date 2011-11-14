From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] tune2fs: Compute quota usage when turning on the
 'quota' feature
Date: Mon, 14 Nov 2011 10:57:44 -0500
Message-ID: <20111114155744.GB7698@thunk.org>
References: <1320365913-25857-1-git-send-email-adityakali@google.com>
 <1320365913-25857-2-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso.mit.edu@google.com, niu@whamcloud.com,
	linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49215 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1KNP5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:57:46 -0500
Content-Disposition: inline
In-Reply-To: <1320365913-25857-2-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2011 at 05:18:32PM -0700, Aditya Kali wrote:
> When turning on the quota feature, tune2fs would create empty quota inodes and
> set their inode numbers in superblock. This required e2fsck to be ran before
> using the quota feature. This patch adds adds call to compute_quota() and make
> sure that we write correct quota information in the quota files at tune2fs time
> itself. This gets rid of the necessity for running e2fsck after setting the
> quota feature. Also, tune2fs now does not use existing old quota files
> (aquota.user and aquota.group) even if they exist.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Thanks, applied.

					- Ted
