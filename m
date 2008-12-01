From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [ext4] Documentation patch
Date: Mon, 01 Dec 2008 11:58:52 -0600
Message-ID: <493425DC.1010008@redhat.com>
References: <8763m3u9kv.fsf@basilikum.skogtun.org> <20081201165700.GA26680@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Arnesen <skogtun.harald@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYLAR7f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Dec 2008 12:59:35 -0500
In-Reply-To: <20081201165700.GA26680@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Dec 01, 2008 at 05:46:56PM +0100, Harald Arnesen wrote:
>>      So when comparing with a metadata-only journalling filesystem, such
>> -    as ext3, use `mount -o data=writeback'.  And you might as well use
>> +    as jfs or xfs, use `mount -o data=writeback'.  And you might as well use
> 
> data=ordered comes closest to what xfs does for quite a long time..

Agreed; that whole bit which mentions other filesystem comparisons
should probably be stricken, unless it can be
proven/demonstrated/substantiated that ext3 really does "offer higher
data integrity guarantees than most" at this point.

data=ordered ensures that stale data won't be exposed on a crash; xfs
won't do this (it'd be a security bug) and I'd be surprised if jfs or
reiserfs do either.    And it probably *should* be mentioned that
data=writeback bears this risk.

And until ext3 turns on barriers by default, I don't think it's fair to
talk too much about integrity guarantees.  :)

-Eric
