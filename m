From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Tue, 18 Mar 2008 08:11:32 -0500
Message-ID: <47DFBF84.5070207@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com> <20080318042339.GO8368@mit.edu> <47DF5045.1000108@redhat.com> <20080318110145.GQ8368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYCRNL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2008 09:11:56 -0400
In-Reply-To: <20080318110145.GQ8368@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> I rejected this approach originally because it would mean reusing the
> -t option right away.  But maybe this would be easier for users to
> understand, and easier to document in the man pages, and maybe that's
> an overriding consideration.


well, I doubt the man page should override much ;)

I just wanted to air the concerns & my ideas... if, having considered
them, you're still happy with the original approach, that's fine with me.

Thanks,

-Eric
