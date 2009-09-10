From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Thu, 10 Sep 2009 16:42:53 -0500
Message-ID: <4AA972DD.3090607@redhat.com>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com> <20090910213337.GC6705@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZIJVmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 17:42:53 -0400
In-Reply-To: <20090910213337.GC6705@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 04:16:32PM -0500, Eric Sandeen wrote:
>> Ok, fine by me.  I can send an update.
>>
>> Any suggestions on the naming issues?  (what's the official name for a
>> "not-extent-based-file?")
> 
> What I normally use is "extent-mapped file" and "indirect block mapped
> file", or "non-extent-mapped file".

I'll see if that can fit in a macro name nicely :)

Thanks,
-Eric

> 						- Ted

