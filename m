From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 patchqueue corrupted ?
Date: Fri, 11 Jul 2008 18:01:09 +0530
Message-ID: <20080711123109.GA14606@skywalker>
References: <20080711034606.GA779@skywalker> <20080711084715.GT10151@machine.or.cz> <20080711122617.GA8154@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Petr Baudis <pasky@suse.cz>, Ming Ming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	git@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:59372 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751977AbYGKMbh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 08:31:37 -0400
Content-Disposition: inline
In-Reply-To: <20080711122617.GA8154@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 11, 2008 at 08:26:17AM -0400, Theodore Tso wrote:
> On Fri, Jul 11, 2008 at 10:47:15AM +0200, Petr Baudis wrote:
> >   very puzzling; I have backed up the broken objects store, can you
> > repush, please? I'm curious about how this could have happenned;
> > repo.or.cz now uses Git from latest next, which is a rather strange
> > coincidence. ;-) Or did any of the pushers do anything special about
> > pushin to the repository recently?
> 
> Aneesh, did you try repushing?  It looks like the objects store is
> broken again.

I don't have permission to push to the repo. I can only pull.


> 
> Pasky, in case it helps, and for the benefit of Linux-ext4 folks, I
> have a copy of my repository (which I last pushed to repo.or.cz around
> noon US/Eastern yesterday) here:
> 
>      git://git.kernel.org/pub/scm/fs/ext2/ext4-patch-queue.git
> 
> My most recent HEAD is ec90e411; if anyone has something more recent,
> they can send it to me via:
> 
>      git bundle create /tmp/to-send ec90e411
> 
> ... and then e-mailing me as an attachment the resulting binary file
> in /tmp/to-send.
> 

-aneesh
