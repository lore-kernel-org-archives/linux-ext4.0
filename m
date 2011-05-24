From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: reserve inodes and feature code for 'quota'
 feature
Date: Tue, 24 May 2011 19:01:50 -0400
Message-ID: <20110524230150.GL26055@thunk.org>
References: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40235 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247Ab1EXXBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 19:01:52 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 05:06:50PM -0800, Aditya Kali wrote:
> I am working on patch to add quota as a built-in feature for ext4
> filesystem. The implementation is based on the design given at
> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4.
> This patch reserves the inode numbers 3 and 4 for quota purposes and
> also reserves EXT4_FEATURE_RO_COMPAT_QUOTA feature code.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

I noted that this fell through the cracks; my apologies!  I've applied
this to the ext4 tree.

						- Ted
