From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: remove unnecessary operation in
	ext4_mb_regular_allocator()
Date: Wed, 24 Mar 2010 20:14:46 +0800
Message-ID: <ac8f92701003240514l77f5b597h605b06b5f6140674@mail.gmail.com>
References: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
	 <20100322182645.GI11560@thunk.org>
	 <ac8f92701003230540w5a788ec1s54737e2e38c90e11@mail.gmail.com>
	 <20100323165621.GO11560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48917 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0CXMOq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 08:14:46 -0400
Received: by gyg8 with SMTP id 8so3665129gyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 05:14:46 -0700 (PDT)
In-Reply-To: <20100323165621.GO11560@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/24, tytso@mit.edu <tytso@mit.edu>:
> Thanks for separating the patches!
>
> Since you included a Signed-off-by in the earlier version of the
> patches, I'll assume it applies two these two patches.  For future
> reference, though, it saves me time and effort if you follow the
> guidelines specified in Documentation/SubmittingPatches, especially
> the section 15, ("The canonical patch format") which talks about using
> a separate e-mail for each patch (chained together using the
> In-reply-to: mail header fields).
>
> Among other reasons, it allows me to keep track of patches using the
> patchwork tool (see: http://patchwork.ozlabs.org/project/linux-ext4)
> so I don't forget about patches which are sent to me.  It also allows
> me to use tools such as "git am" to automatically apply patches.
>
> Note that there are tools like "git format-patches" and "git
> send-email" which make it very easy to send out patches which are
> compliant to the these recomendations.  They are not required, but
> they do make your job easier.
>
> I'll fix up these patches by hand, so it's no big deal, but in the
> future, it streamlines things if you follow the SubmittingPatches
> guidelines.  (See also the SubmitChecklist in the Documentation
> directory of the Linux sources).
>
> Many thanks,
>
> 						- Ted
>

Evening,

Sorry for my last reply that causes you have to deal the patches by
hand, and thank you, Ted, for your patience.

I will try hard to follow the guidelines specified in
Documentation/SubmittingPatches, and to learn how to git
format-patches.

Best
        - zj
