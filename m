From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 07 Sep 2011 16:23:31 +0900
Message-ID: <20110907162331.371D.61FB500B@jp.fujitsu.com>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com> <20110907064006.GA16042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34878 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1IGRVs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Sep 2011 13:21:48 -0400
In-Reply-To: <20110907064006.GA16042@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(2011/09/07 15:40), Christoph Hellwig wrote:

> On Wed, Sep 07, 2011 at 12:29:30PM +0900, Masayoshi MIZUMA wrote:
> > Hi,
> > 
> > When I checked the freeze feature for ext3 filesystem using fsfreeze
> > command at 3.1.0-rc4, I think the following deadlock problem happened.
> > 
> > How to reproduce:
> >  # mkfs -t ext3 /dev/sdd1
> >  # mount /dev/sdd1 /MNT
> >  # ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
> >  # fsfreeze -f /MNT
> >  # fsfreeze -u /MNT
> 
> Can you add this testcase to xfstests?

I don't know how to add this testcase to xfstests much, but I will
try to create it.
Please wait for a while...

Thanks,
Masayoshi


