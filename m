From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Mon, 2 May 2011 12:38:49 -0400
Message-ID: <20110502163848.GB10127@infradead.org>
References: <4DBE746F.3090707@ubuntu.com>
 <20110502105629.GA4556@quack.suse.cz>
 <4DBE9537.4050708@ubuntu.com>
 <20110502122055.GB5855@quack.suse.cz>
 <4DBEA3DF.1060306@ubuntu.com>
 <20110502131619.GC5855@quack.suse.cz>
 <20110502132204.GA7708@infradead.org>
 <20110502142055.GF4556@quack.suse.cz>
 <20110502144155.GA8045@infradead.org>
 <20110502162334.GJ4556@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Surbhi Palande <surbhi.palande@ubuntu.com>,
	Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1EBQi4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 12:38:56 -0400
Content-Disposition: inline
In-Reply-To: <20110502162334.GJ4556@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 06:23:34PM +0200, Jan Kara wrote:
>   But why should it block when xfs_wait_for_freeze() gets called before
> freeze_super() gets called? The other thread calls freeze_super() just
> after xfs_wait_for_freeze() in thread 1 and before _xfs_trans_alloc() gets
> called.  Or am I missing some serialization somewhere?

Oh, now I get the race window you mean.  It's the single instruction
window between doing the frozen check and incrementing m_active_trans.

Yes, that one looks real, although very unlikely to hit.  Could be fixed
relatively easily by moving the check after the increment.
