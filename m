From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V4 2/2] ext4: Use -1 as the fake block number for	delayed
 new buffer_head
Date: Mon, 04 May 2009 10:06:19 -0500
Message-ID: <49FF046B.9060001@redhat.com>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090429153521.GC14264@mit.edu> <20090504085423.GA12391@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZEDPGZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 11:06:25 -0400
In-Reply-To: <20090504085423.GA12391@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Wed, Apr 29, 2009 at 11:35:21AM -0400, Theodore Tso wrote:
>> On Wed, Apr 29, 2009 at 10:17:21AM +0530, Aneesh Kumar K.V wrote:
>>> Block number '0' should not be used as the fake block number for
>>> the delayed new buffer. This will result in vfs calling umap_underlying_metadata for
>>> block number '0'. So  use -1 instead.
>> sector_t is an unsigned type, so we probably want to use ~0 instead of
>> -1.  I can fix this up before we apply into the patch queue.
>>
>> Are we agreed both of these should probably be pushed to Linus for
>> 2.6.30?
>>
> 
> With ABAT I am seeing the below error during fsstress run.
> 
> EXT4-fs: mounted filesystem sdb1 with ordered data mode
> attempt to access beyond end of device
> sdb1: rw=1, want=0, limit=136713087
> Buffer I/O error on device sdb1, logical block 18446744073709551615

Ok, I think this is actually good.  Looks like we are leaking
uninitialized delalloc buffer heads... this may well explain some of the
corruptions we've seen.  So now .... what's going on ... :)

-Eric
