From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Thu, 10 Sep 2009 11:56:51 -0500
Message-ID: <4AA92FD3.2010301@redhat.com>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910165327.GB23700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZIJQ4w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 12:56:52 -0400
In-Reply-To: <20090910165327.GB23700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 11:02:15AM -0500, Eric Sandeen wrote:
>> Today, the ext4 allocator will happily allocate blocks past
>> 232 for indirect-block files, which results in the block
>> numbers getting truncated, and corruption ensues.
> 
> Everywhere where you say 232, you mean 2^32, right?

sorry, cut and paste error, yes.

(email client helpfully turned 2^32 into something prettier, but then
didn't copy it right on the resend)

-Eric
