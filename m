From: tytso@mit.edu
Subject: Re: [PATCH] ext4: remove unnecessary operation in
 ext4_mb_regular_allocator()
Date: Tue, 23 Mar 2010 12:56:21 -0400
Message-ID: <20100323165621.GO11560@thunk.org>
References: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
 <20100322182645.GI11560@thunk.org>
 <ac8f92701003230540w5a788ec1s54737e2e38c90e11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47233 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0CWQ4p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Mar 2010 12:56:45 -0400
Content-Disposition: inline
In-Reply-To: <ac8f92701003230540w5a788ec1s54737e2e38c90e11@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for separating the patches!

Since you included a Signed-off-by in the earlier version of the
patches, I'll assume it applies two these two patches.  For future
reference, though, it saves me time and effort if you follow the
guidelines specified in Documentation/SubmittingPatches, especially
the section 15, ("The canonical patch format") which talks about using
a separate e-mail for each patch (chained together using the
In-reply-to: mail header fields).

Among other reasons, it allows me to keep track of patches using the
patchwork tool (see: http://patchwork.ozlabs.org/project/linux-ext4)
so I don't forget about patches which are sent to me.  It also allows
me to use tools such as "git am" to automatically apply patches.

Note that there are tools like "git format-patches" and "git
send-email" which make it very easy to send out patches which are
compliant to the these recomendations.  They are not required, but
they do make your job easier.

I'll fix up these patches by hand, so it's no big deal, but in the
future, it streamlines things if you follow the SubmittingPatches
guidelines.  (See also the SubmitChecklist in the Documentation
directory of the Linux sources).

Many thanks,

						- Ted
