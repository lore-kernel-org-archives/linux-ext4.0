From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH -v3] Add support for new compat feature "sparse_super2"
Date: Wed, 22 Jan 2014 14:57:03 -0200
Message-ID: <20140122165701.GA4351@orion.maiolino.org>
References: <1389999248-11960-1-git-send-email-tytso@mit.edu>
 <20140122133813.GA21687@orion.maiolino.org>
 <20140122165103.GA11233@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaAVQ5I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jan 2014 11:57:08 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0MGv8gB032499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jan 2014 11:57:08 -0500
Received: from orion.maiolino.org (ovpn-113-96.phx2.redhat.com [10.3.113.96])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s0MGv4Qq009662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jan 2014 11:57:07 -0500
Content-Disposition: inline
In-Reply-To: <20140122165103.GA11233@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kk,

On Wed, Jan 22, 2014 at 11:51:03AM -0500, Theodore Ts'o wrote:
> On Wed, Jan 22, 2014 at 11:38:13AM -0200, Carlos Maiolino wrote:
> > Hi Ted, in which tree you based this patch?
> 
> This was based on the maint branch, since I wanted to make sure that
> if we release a 1.42.10, that e2fsck can deal with file systems with
> this compat feature.
> 
> I need to get an updated maint branch published, since I have a number
> of fixes in my tree.  I had been busy cleaning up a lot of patches,
> which I had been doing on the maint branch in my local tree.  What I
> need to do is to figure out which ones I'm ready to cast into
> concrete, and then move the rest into a dev brach.  I'll try to get
> that done in the next day or two.
> 

Don't worry, I was just wondering if I was doing something wrong here, while
reviewing the patch.

take your time.
Cheers,

> 				- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
