From: James Morris <jmorris@namei.org>
Subject: Re: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
Date: Fri, 4 Apr 2008 10:02:39 +1100 (EST)
Message-ID: <Xine.LNX.4.64.0804041001410.23232@us.intercode.com.au>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
 <6495.1207163569@turing-police.cc.vt.edu>  <20080402192715.GA32454@unused.rdu.redhat.com>
  <20080402123905.386c56f8.akpm@linux-foundation.org>
 <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <jbacik@redhat.com>, Valdis.Kletnieks@vt.edu,
	sct@redhat.com, jack@suse.cz, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, eparis@redhat.com
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:47999 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbYDCXFQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:16 -0400
In-Reply-To: <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Apr 2008, Stephen Smalley wrote:

> > > Try this patch, it will keep us from re-entering the fs when we aren't supposed
> > > to.  cc'ing Eric Paris since he's the only selinux guy I know :).  I don't think

Please see the MAINTAINERS file.

> > > any of the other allocations in here need to be fixed, but I didn't look too
> > > carefully.
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@redhat.com>

Thanks, I'll push this to Linus, but note that further analysis is 
required.


-- 
James Morris
<jmorris@namei.org>
