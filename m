From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] mke2fs: Allow specifying reserved_ratio via
 mke2fs.conf
Date: Sat, 14 May 2011 23:35:12 -0400
Message-ID: <20110515033512.GG21165@thunk.org>
References: <1305064291-14963-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lczerner@redhat.com, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35068 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1EODfW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 May 2011 23:35:22 -0400
Content-Disposition: inline
In-Reply-To: <1305064291-14963-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 02:51:31PM -0700, Aditya Kali wrote:
> This patch adds support for specifying 'reserved_ratio' (percent blocks
> reserved for super user, same as '-m' command line option) in mke2fs.conf.
> It adds profile_get_double function in profile.c that allows reading
> floating point values from profile files.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Thanks, I've added this patch to the e2fsprogs "next" branch.

	     	   	      	     	       - Ted
