From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do less extent validations
Date: Fri, 27 Mar 2009 16:54:41 -0400
Message-ID: <20090327205441.GF6239@mit.edu>
References: <49B92B26.70402@ph.tum.de> <49BEA2FA.5070703@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42341 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbZC0Uyp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 16:54:45 -0400
Content-Disposition: inline
In-Reply-To: <49BEA2FA.5070703@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 16, 2009 at 08:05:30PM +0100, Thiemo Nagel wrote:
> Thiemo Nagel wrote:
>>
>> Based on 2.6.29-rc7 with Aneesh Kumar's patches:
>> ext4: Validate extent details only when read from the disk
>> ext4: Add checks to validate extent entries
>>
>> Sets need_to_validate=0 inside instead of outside the loop.
>
> OTOH, why not remove the variable altogether?  (cf. attached patch)

This patch causes ext4_ext_check to be called before the variables eh
is set, and before variable is updated.

					- Ted
