From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Mon, 17 Sep 2012 11:37:01 -0400
Message-ID: <20120917153701.GA5510@thunk.org>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
 <20120915183023.GA9895@thunk.org>
 <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51118 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2IQPhK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 11:37:10 -0400
Content-Disposition: inline
In-Reply-To: <50574226.3020908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 17, 2012 at 10:30:46AM -0500, Eric Sandeen wrote:
> fwiw, the uninit variable came about as part of
> 2ed886852adfcb070bf350e66a0da0d98b2f3ab5; before that we happily
> returned 0 for an unmapped block; see below.  So unless something
> else has changed since then, Carlos' patch shouldn't be doing any
> harm, at least.  An audit may be in order but anyone
> misunderstanding a NULL/0 return has probably been that way for a
> while.

Hmm, good point.

This is an audit that needs to happen for ext3 and ext4 as well, BTW
--- the callers of ext3_getblk() don't do the right thing when
ext3_getblk returns NULL and sets *errp to zero.

Fortunately it's rare that we have directories with holes, but there
are definitely bugs in terms of undefined behavior in the case of
directories with holes that we should look at and fix.

	    	       	       	      	      - Ted

