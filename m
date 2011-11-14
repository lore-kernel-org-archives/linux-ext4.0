From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libquota: cleanup libquota code
Date: Mon, 14 Nov 2011 10:57:29 -0500
Message-ID: <20111114155729.GA7698@thunk.org>
References: <1320365913-25857-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso.mit.edu@google.com, niu@whamcloud.com,
	linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49209 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1KNP5f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:57:35 -0500
Content-Disposition: inline
In-Reply-To: <1320365913-25857-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2011 at 05:18:31PM -0700, Aditya Kali wrote:
> This patch cleans up the quota code as suggested in previous reviews. This
> includes
> * remove BUG_ON()s and 'exit()' calls from library code
> * remove calls to malloc/free and instead use ext2fs_get/free_mem functions.
> * lib/quota/common.c file in not needed anymore and is removed.
> * rename exported functions to start with quota_
>   (ex: init_quota_context --> quota_init_context)
> * better error handling in quota library
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Thanks, applied.

					- Ted
