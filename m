From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 7 Sep 2011 12:50:17 -0400
Message-ID: <20110907165017.GA19151@infradead.org>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com>
 <20110907064006.GA16042@infradead.org>
 <CAGpXXZL=+K0ETvM0kGE6zqe3pB7AS_exU+dCbpm+uUSG2JJ+0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60967
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab1IGQut (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Sep 2011 12:50:49 -0400
Content-Disposition: inline
In-Reply-To: <CAGpXXZL=+K0ETvM0kGE6zqe3pB7AS_exU+dCbpm+uUSG2JJ+0A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 07, 2011 at 12:45:34PM -0400, Greg Freemyer wrote:
> > Can you add this testcase to xfstests?
> 
> Christoph,
> 
> Isn't that just a matter of extending test 068 to ext4

If you have recent enough xfsprogs that allow the freeze command
for foreign filesystems that might work. 

