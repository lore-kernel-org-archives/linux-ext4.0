From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 7 Sep 2011 02:40:07 -0400
Message-ID: <20110907064006.GA16042@infradead.org>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36676
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab1IGGkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Sep 2011 02:40:20 -0400
Content-Disposition: inline
In-Reply-To: <20110907122929.3715.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 07, 2011 at 12:29:30PM +0900, Masayoshi MIZUMA wrote:
> Hi,
> 
> When I checked the freeze feature for ext3 filesystem using fsfreeze
> command at 3.1.0-rc4, I think the following deadlock problem happened.
> 
> How to reproduce:
>  # mkfs -t ext3 /dev/sdd1
>  # mount /dev/sdd1 /MNT
>  # ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
>  # fsfreeze -f /MNT
>  # fsfreeze -u /MNT

Can you add this testcase to xfstests?

