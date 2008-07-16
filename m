From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 13:18:24 -0400
Message-ID: <20080716171824.GE2167@mit.edu>
References: <20080715164332.28567.27913.stgit@ichigo> <20080715165129.28567.7837.stgit@ichigo> <87tzeq0z95.fsf@frosties.localdomain> <87ej5ugcn2.fsf@frosties.localdomain> <20080716091846.44174452@ichigo> <877ibl97jy.fsf@frosties.localdomain> <20080716110242.7cffffa5@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47944 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750975AbYGPRS1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 13:18:27 -0400
Content-Disposition: inline
In-Reply-To: <20080716110242.7cffffa5@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 11:02:42AM -0500, Jose R. Santos wrote:
> > PS: Should functions that chop off upper bits like that make sure they
> > are 0?
> 
> I think this is something that need to be cheched at fsck since having
> these be non-zero on a non-64-bit FS should be pointing to file system
> corruption.  Not sure if its something that need to be done every time
> we set a value on the lower bit only though.

Well, to quote Postel's law (also known as the robustness principle):
"Be conservative in what you do; be liberal in what you accept from
others."  

This is a generalization from what Jon Postel wrote in RFC 793: "TCP
implementations will follow a general principle of robustness: be
conservative in what you do, be liberal in what you accept from
others," but it applies here as well.  So yes, the library code should
clear the upper bits even if 64-bit feature flag is not set.  However,
we should not depend on the upper bits being zero if the 64-bit
feature flag is not set.

Does that make sense?

					- Ted


