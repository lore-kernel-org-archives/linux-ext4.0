From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 7 Sep 2011 13:17:28 -0400
Message-ID: <20110907171728.GA11314@infradead.org>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com>
 <20110907064006.GA16042@infradead.org>
 <CAGpXXZL=+K0ETvM0kGE6zqe3pB7AS_exU+dCbpm+uUSG2JJ+0A@mail.gmail.com>
 <20110907165017.GA19151@infradead.org>
 <4E67A56F.8040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36247
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab1IGRRk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Sep 2011 13:17:40 -0400
Content-Disposition: inline
In-Reply-To: <4E67A56F.8040403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 07, 2011 at 12:10:07PM -0500, Eric Sandeen wrote:
> > If you have recent enough xfsprogs that allow the freeze command
> > for foreign filesystems that might work. 
> 
> where "recent enough" is since Tue Feb 10 14:41:51 2009 -0600
> 
> I say go for it :)
> 
> Could always add a quick helper to make sure the xfs_io command
> doesn't fail on freeze, and _notrun if it does.

With the _notrun trick it could probably even claim generic fs
support.

