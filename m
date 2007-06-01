From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 1 Jun 2007 14:13:39 +0200
Message-ID: <20070601121339.GF7217@one.firstfloor.org>
References: <1179777153.3910.13.camel@garfield> <p731wgwcbac.fsf@bingen.suse.de> <20070601114100.GB13905@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41652 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFAMNn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 08:13:43 -0400
Content-Disposition: inline
In-Reply-To: <20070601114100.GB13905@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Unfortunately, it's not possible to do what you suggest, since one of
> the whole points of increasing the sequence number every 5 seconds is
> to act as a keep-alive, so another machine trying to access the shared

Clusters usually have other ways to do this, haven't they? 
Typically they have STONITH too. It's probably too simple minded
to just replace a real cluster setup which also handles split 
brain and other conditions. So it's purely against mistakes.

Besides relying on it would seem dangerous because it is not synchronous
and you could do a lot of damage in 5 seconds. 

The rationale of the lazy writing would be that at least in usual
operation super block should be written regularly and with
5 seconds delay just being a not fully reliable heuristic it probably 
doesn't matter if the possible delay is a little longer even. 

-Andi
