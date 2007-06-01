From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 1 Jun 2007 09:52:41 -0400
Message-ID: <20070601135241.GB28663@thunk.org>
References: <1179777153.3910.13.camel@garfield> <p731wgwcbac.fsf@bingen.suse.de> <20070601114100.GB13905@thunk.org> <20070601121339.GF7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49049 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760080AbXFANwp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2007 09:52:45 -0400
Content-Disposition: inline
In-Reply-To: <20070601121339.GF7217@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 01, 2007 at 02:13:39PM +0200, Andi Kleen wrote:
> > Unfortunately, it's not possible to do what you suggest, since one of
> > the whole points of increasing the sequence number every 5 seconds is
> > to act as a keep-alive, so another machine trying to access the shared
> 
> Clusters usually have other ways to do this, haven't they? 
> Typically they have STONITH too. It's probably too simple minded
> to just replace a real cluster setup which also handles split 
> brain and other conditions. So it's purely against mistakes.

Yes, it's only real value is to protect against Cluster-HA
malfunctions or misconfiguration.

> Besides relying on it would seem dangerous because it is not synchronous
> and you could do a lot of damage in 5 seconds. 

Well, the MMP feature is assigned an incompatible feature bit, so a
kernel who doesn't know about MMP will refuse to touch it; and a
kernel which does follow the MMP protocol will check the MMP block
(delaying the mount by 10 seconds) to make sure no other system is
using the block.

So aside from being !@#!@ annoying (which is why it will never be the
default), it does work, modulo the problem that without STONITH or any
kind of I/O fencing, we do risk the other system coming back to life
and then modifying the filesystem in parallel.  So as everyone has
said, this is not solution that works in isolation, but is really only
a backup.

The question of whether the complexity and then 10 second mount delay
for what is only a backup solution is worth it is obviously going to
be a very subjective one --- and as I've said previously, I'm on the
fence on this.

						- Ted
