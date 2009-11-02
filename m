From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 04/27] ext2: Add ext2_sb_info mutex
Date: Mon, 2 Nov 2009 18:25:54 +0100
Message-ID: <20091102172554.GH31511@one.firstfloor.org>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-5-git-send-email-jblunck@suse.de> <20091102102654.GG31511@one.firstfloor.org> <20091102165752.GF21750@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56450 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbZKBRZu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2009 12:25:50 -0500
Content-Disposition: inline
In-Reply-To: <20091102165752.GF21750@bolzano.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Right. I converted it to be a spinlock and unlock before calling
> ext2_sync_super().
> 
> What do you think?

Again didn't go through all the code paths, but it seems like a good
approach.

-Andi
