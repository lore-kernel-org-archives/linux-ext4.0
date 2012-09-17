From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Mon, 17 Sep 2012 15:26:04 -0300
Message-ID: <20120917182604.GA1959@andromeda.usersys.redhat.com>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
 <20120915183023.GA9895@thunk.org>
 <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
 <20120917153701.GA5510@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab2IQS0I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 14:26:08 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8HIQ8e2032321
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 14:26:08 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-119.phx2.redhat.com [10.3.113.119])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8HIQ53c010981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 14:26:07 -0400
Content-Disposition: inline
In-Reply-To: <20120917153701.GA5510@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 17, 2012 at 11:37:01AM -0400, Theodore Ts'o wrote:
> On Mon, Sep 17, 2012 at 10:30:46AM -0500, Eric Sandeen wrote:
> > fwiw, the uninit variable came about as part of
> > 2ed886852adfcb070bf350e66a0da0d98b2f3ab5; before that we happily
> > returned 0 for an unmapped block; see below.  So unless something
> > else has changed since then, Carlos' patch shouldn't be doing any
> > harm, at least.  An audit may be in order but anyone
> > misunderstanding a NULL/0 return has probably been that way for a
> > while.
> 
> Hmm, good point.
> 
> This is an audit that needs to happen for ext3 and ext4 as well, BTW
> --- the callers of ext3_getblk() don't do the right thing when
> ext3_getblk returns NULL and sets *errp to zero.
> 
> Fortunately it's rare that we have directories with holes, but there
> are definitely bugs in terms of undefined behavior in the case of
> directories with holes that we should look at and fix.
> 
> 	    	       	       	      	      - Ted
> 
Ted,

based on this conversation, is there anything else I should do to have this
patch accepted?

btw, I can review the callers for ext4_bread() and ext3_getblk in order to audit
it, is that ok for you?
-- 
--Carlos
