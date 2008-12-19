From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vfs: introduce helper function to safely NUL-terminate
 symlinks
Date: Fri, 19 Dec 2008 11:28:39 -0800
Message-ID: <20081219112839.2748c467.akpm@linux-foundation.org>
References: <1229442720-31056-3-git-send-email-duaneg@dghda.com>
	<1229442720-31056-4-git-send-email-duaneg@dghda.com>
	<1229442720-31056-5-git-send-email-duaneg@dghda.com>
	<1229442720-31056-1-git-send-email-duaneg@dghda.com>
	<1229442720-31056-6-git-send-email-duaneg@dghda.com>
	<1229442720-31056-2-git-send-email-duaneg@dghda.com>
	<20081216234638.GX5000@webber.adilger.int>
	<e9e943910812161626i6f2cdc3eldc36c68e9a98f180@mail.gmail.com>
	<e9e943910812190703w6fb43cebmfe96f2a2e8cc47dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, adilger@sun.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYLST3K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2008 14:29:10 -0500
In-Reply-To: <e9e943910812190703w6fb43cebmfe96f2a2e8cc47dd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 19 Dec 2008 15:03:52 +0000
"Duane Griffin" <duaneg@dghda.com> wrote:

> 2008/12/17 Duane Griffin <duaneg@dghda.com>:
> > It is true for sysv, too. The ufs code also, but that has other
> > issues, anyway. The generic page symlink and freevxfs patches should
> > be fine, though.
> 
> Before I fire off another set of patches, should I be sending out the
> complete set again or just the ones that need to be updated?
> 

It's more reliable to resend everything.
