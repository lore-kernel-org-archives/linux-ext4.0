From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Remove "extents" mount option
Date: Wed, 07 Jan 2009 09:47:40 -0600
Message-ID: <4964CE9C.2050505@redhat.com>
References: <1231267777-18831-1-git-send-email-tytso@mit.edu> <20090107053250.GA9617@skywalker> <20090107144502.GC17110@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693AbZAGPsI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 10:48:08 -0500
In-Reply-To: <20090107144502.GC17110@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> What's the scenario you're thinking about here?  When would it be
> useful for users to be able to downgrade extent-based files to
> indirect block files by copying files around?
> 
> 						- Ted

We have said in the past that this is a path back out of ext4 if you
regret your decision to migrate.

And if you have simply tune2fs -O extent'd your old ext3 fs, then the
above *is* a (cumbersome) way back out in most cases I think...

-Eric
