From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use kzalloc in ext4_kzalloc()
Date: Wed, 3 Aug 2011 14:57:56 -0400
Message-ID: <20110803185756.GE3150@thunk.org>
References: <1312204398-12460-2-git-send-email-tytso@mit.edu>
 <1312265235-19978-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55209 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab1HCS57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2011 14:57:59 -0400
Content-Disposition: inline
In-Reply-To: <1312265235-19978-1-git-send-email-minipli@googlemail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 02, 2011 at 08:07:15AM +0200, Mathias Krause wrote:
> Commit 9933fc0i (ext4: introduce ext4_kvmalloc(), ext4_kzalloc(), and
> ext4_kvfree()) intruduced wrappers around k*alloc/vmalloc but introduced
> a typo for ext4_kzalloc() by not using kzalloc() but kmalloc().
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Oops.  Thanks for catching this.  I'll make sure this gets pushed to
Linus ASAP.

					- Ted
