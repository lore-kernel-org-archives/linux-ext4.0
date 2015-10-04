From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: clean up feature flag checking and usage
Date: Sun, 4 Oct 2015 19:12:12 -0400
Message-ID: <20151004231212.GD4442@thunk.org>
References: <1443865028-5943-1-git-send-email-adilger@dilger.ca>
 <1443865028-5943-2-git-send-email-adilger@dilger.ca>
 <20151003223609.GK3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59452 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbbJDXMQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Oct 2015 19:12:16 -0400
Content-Disposition: inline
In-Reply-To: <20151003223609.GK3902@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 04, 2015 at 09:36:09AM +1100, Dave Chinner wrote:
> Rather than making it hard to use cscope/ctags to find the users of
> these feature flags, wouldn't it be better to turn this around the
> other way similar to the way XFS does this? i.e.:
> 
>  -	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +	if (ext4_has_feature_flex_bg(sb))
> 
> static inline ext4_has_feature_flex_bg(struct super_block *sb)
> {
> 	return EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG);
> }
> 
> That way the code doing the feature checks is clear and concise, is
> much less shouty and it's not cluttered by whether features are in
> the incompat, ro or compat matrices. As a bonus, cscope still works
> just fine.

Nice suggestion, thanks!   I agree this would be better.

     		 	     	   	- Ted
