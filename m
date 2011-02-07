From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] mballoc: trivial code cleanup
Date: Mon, 7 Feb 2011 17:24:50 -0500
Message-ID: <20110207222450.GF3457@thunk.org>
References: <4D4E294E.4080507@coly.li>
 <AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
 <20110207174125.GB3457@thunk.org>
 <AANLkTimOaQSdJa9aXEs_UM0pAO92S0_zGT5w7kU33etk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: i@coly.li, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55975 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab1BGWYz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 17:24:55 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimOaQSdJa9aXEs_UM0pAO92S0_zGT5w7kU33etk@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 07, 2011 at 10:59:54PM +0200, Amir Goldstein wrote:
> it says alloc_sem protects against lazy init of adjacent groups
> and says nothing about protecting block group specific data structures...
> 
> what am I missing???

You're missing ext4_mb_load_buddy(), which takes grp->alloc_sem, and
which is released by ext4_mb_unload_buddy().  No, it's not the most
obvious code in the world...

					- Ted


