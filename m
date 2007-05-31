From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch 0/2] i_version update
Date: Thu, 31 May 2007 08:36:50 -0400
Message-ID: <1180615010.6696.45.camel@heimdal.trondhjem.org>
References: <46570DFB.3080101@bull.net> <20070530002100.GV85884050@sgi.com>
	 <18014.4211.68725.44217@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pat.uio.no ([129.240.10.15]:47688 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760457AbXEaMg6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 08:36:58 -0400
In-Reply-To: <18014.4211.68725.44217@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-05-31 at 10:01 +1000, Neil Brown wrote:

> This will provide a change number that normally changes only when the
> file changes and doesn't require any extra storage on disk.
> The change number will change inappropriately only when the inode has
> fallen out of cache and is being reload, which is either after a crash
> (hopefully rare) of when a file hasn't been used for a while, implying
> that it is unlikely that any client has it in cache.

It will also change inappropriately if the server is under heavy load
and needs to reclaim memory by tossing out inodes that are cached and
still in use by the clients. That change will trigger clients to
invalidate their caches and to refetch the data from the server, further
cranking up the load.

Not an ideal solution...

Trond
