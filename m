From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 12:13:01 -0600
Message-ID: <52B1E5AD.9070009@redhat.com>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab3LRSNH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Dec 2013 13:13:07 -0500
In-Reply-To: <20131217223050.GB20579@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/17/13, 4:30 PM, Dave Chinner wrote:
> On Tue, Dec 17, 2013 at 02:18:25PM -0500, Matthew Wilcox wrote:
>> For v3, we've addressed the problem with unwritten extents that Dave
>> Chinner pointed out. 
> 
> No, you haven't addressed the problem. There is nothing in this
> patch set that converts an unwritten extent after it is written to.
> Hence on every subsequent read will return zeros because the block
> is still marked as unwritten.

I'd really strongly encourage you guys to try running through xfstests.

IF you haven't seen this stuff fail yet, you're apparently not
testing these paths - I'm guessing xfstests may expose these holes
quite well.

I'd be happy to help you get up & running on xfstests if you need a
hand.

-Eric

