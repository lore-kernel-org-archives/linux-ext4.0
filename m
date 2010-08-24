From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Fix EXT4_FEATURE_RO_COMPAT_HUGE_FILE check
Date: Mon, 23 Aug 2010 22:34:14 -0600
Message-ID: <426FFD16-98B3-4427-BDA5-C80CE184781C@dilger.ca>
References: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:13126 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0HXEeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Aug 2010 00:34:16 -0400
In-Reply-To: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-23, at 19:34, Justin Maggard wrote:
> Creating a 4TB file on a filesystem with the 64bit flag set results in e2fsck consistently complaining about i_blocks being wrong, with confusing messages like this:
> 
> That appears to be caused by ext2fs_inode_i_blocks() checking for the EXT4_FEATURE_RO_COMPAT_HUGE_FILE in the wrong place.  Fix it.
> 
> -		((fs->super->s_feature_incompat &
> +		((fs->super->s_feature_ro_compat &
> 		  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?

This isn't the first time that we've had problems like this, and it won't be the last time unless there is a better API for checking these flags.

I've long thought about having something like:

#define EXT4_CHECK_COMPAT(sb, flag)    ((super)->s_feature_compat &     \
                                          EXT4_FEATURE_COMPAT_ ## flag)
#define EXT4_CHECK_RO_COMPAT(sb, flag) ((super)->s_feature_ro_compat &     \
                                          EXT4_FEATURE_RO_COMPAT_ ## flag)
#define EXT4_CHECK_INCOMPAT(sb, flag)  ((super)->s_feature_incompat &     \
                                          EXT4_FEATURE_INCOMPAT_ ## flag)
#define EXT4_SET_COMPAT(sb, flag)    do { (super)->s_feature_compat |=     \
                                         EXT4_FEATURE_COMPAT_ ## flag; } while(0)
#define EXT4_SET_RO_COMPAT(sb, flag) do { (super)->s_feature_ro_compat |=     \
                                         EXT4_FEATURE_RO_COMPAT_ ##flag;} while(0)
#define EXT4_SET_INCOMPAT(sb, flag)  do { (super)->s_feature_incompat |=     \
                                         EXT4_FEATURE_INCOMPAT_ ## flag;} while(0)

This will produce a compile error if the flag name and the macro name don't match. Unfortunately, for e2fsprogs we will need 3 sets of such macros because the feature flags are named EXT2_*, EXT3_*, and EXT4_*, depending on when they were added.  For the kernel code that wouldn't be needed.

Cheers, Andreas





