From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Tue, 29 Dec 2009 13:53:18 -0500
Message-ID: <20091229185318.GJ4429@thunk.org>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
 <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
 <6601abe90912290956s6837803ck76e8c36e96f225ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46076 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZL2Sx0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Dec 2009 13:53:26 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90912290956s6837803ck76e8c36e96f225ae@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 29, 2009 at 09:56:29AM -0800, Curt Wohlgemuth wrote:
> 
> Thanks for pointing out the arithmetic problems in my patch.  Yours
> below looks good to me.

Hi Curt,

Can you do me a favor and send out a full patch with Aneesh's
correction?

Thanks,

					- Ted
