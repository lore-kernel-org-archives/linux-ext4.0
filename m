From: Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
Date: Tue, 21 Feb 2012 08:55:57 -0500
Message-ID: <0E72E3B2-DAA7-45F4-845D-AF4E76174A33@gmail.com>
References: <1329777684-18396-1-git-send-email-haogangchen@gmail.com> <4F42DBA0.4090502@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Haogang Chen <haogangchen@gmail.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55335 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2BUN4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2012 08:56:02 -0500
In-Reply-To: <4F42DBA0.4090502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 20, 2012, at 6:47 PM, Eric Sandeen wrote:
> Hm this raises a few questions I think.
> 
> On the one hand, making sure the kmalloc arg doesn't overflow here is
> certainly a good thing and probably the right thing to do in the short term.
> 
> So I guess:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> for that, to close the hole.

Another possibility is to wait for knalloc/kmalloc_array in the -mm
tree, which is basically the non-zeroing version of kcalloc that
performs overflow checking.

> Doesn't this also mean that a valid s_log_groups_per_flex (i.e. 31)
> will fail in this resize code?  That would be an unexpected outcome.
> 2^31 groups per flex is a little crazy, but still technically valid
> according to the limits in the code.

Or we could limit s_log_groups_per_flex/groups_per_flex to a
reasonable upper bound in ext4_fill_flex_info(), right?

- xi

