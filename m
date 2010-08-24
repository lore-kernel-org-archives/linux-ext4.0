From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Fix EXT4_FEATURE_RO_COMPAT_HUGE_FILE check
Date: Tue, 24 Aug 2010 11:41:11 -0500
Message-ID: <4C73F627.2000809@redhat.com>
References: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com> <426FFD16-98B3-4427-BDA5-C80CE184781C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Justin Maggard <jmaggard10@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0HXQlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Aug 2010 12:41:16 -0400
In-Reply-To: <426FFD16-98B3-4427-BDA5-C80CE184781C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

> This isn't the first time that we've had problems like this, and it
> won't be the last time unless there is a better API for checking
> these flags.

*nod*
 
> I've long thought about having something like:

Same thing crossed my mind; seems like a very good idea.

> #define EXT4_CHECK_COMPAT(sb, flag)    ((super)->s_feature_compat &     \
>                                           EXT4_FEATURE_COMPAT_ ## flag)
> #define EXT4_CHECK_RO_COMPAT(sb, flag) ((super)->s_feature_ro_compat &     \
>                                           EXT4_FEATURE_RO_COMPAT_ ## flag)
> #define EXT4_CHECK_INCOMPAT(sb, flag)  ((super)->s_feature_incompat &     \
>                                           EXT4_FEATURE_INCOMPAT_ ## flag)
> #define EXT4_SET_COMPAT(sb, flag)    do { (super)->s_feature_compat |=     \
>                                          EXT4_FEATURE_COMPAT_ ## flag; } while(0)
> #define EXT4_SET_RO_COMPAT(sb, flag) do { (super)->s_feature_ro_compat |=     \
>                                          EXT4_FEATURE_RO_COMPAT_ ##flag;} while(0)
> #define EXT4_SET_INCOMPAT(sb, flag)  do { (super)->s_feature_incompat |=     \
>                                          EXT4_FEATURE_INCOMPAT_ ## flag;} while(0)
> 
> This will produce a compile error if the flag name and the macro name
> don't match. Unfortunately, for e2fsprogs we will need 3 sets of such
> macros because the feature flags are named EXT2_*, EXT3_*, and
> EXT4_*, depending on when they were added. For the kernel code that
> wouldn't be needed.

Time to name them consistently in e2fsprogs, then, I think?

-Eric

> Cheers, Andreas

