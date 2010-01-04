From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: jbd-debug and jbd2-debug should be writable.
Date: Mon, 4 Jan 2010 23:26:14 +0100
Message-ID: <20100104222614.GB3252@quack.suse.cz>
References: <20091204031735.GN19635@kai-debian>
 <20091204094932.GC4272@skywalker.linux.vnet.ibm.com>
 <20091225204859.GG32757@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Yin, Kangkai" <kangkai.yin@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0ADW0T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jan 2010 17:26:19 -0500
Content-Disposition: inline
In-Reply-To: <20091225204859.GG32757@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 25-12-09 15:48:59, tytso@mit.edu wrote:
> The ext4 portion has been added to the ext4 patch queue.
> 
> Jan, you want to add this to the ext3 tree?
  Thanks for the notification. Actually, I've already sent the original
patch to Linus and that was for both jbd and jbd2. The patch was so trivial
I thought it's not worth splitting it up. I'm sorry if it caused any
trouble to you.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
