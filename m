From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/8] ext4: call ext4_forget() from ext4_free_blocks()
Date: Fri, 23 Jul 2010 09:07:18 -0400
Message-ID: <20100723130718.GC13090@thunk.org>
References: <AANLkTimNATxwmz03ob6UoKzjqeKI6DLuA4FjYvmL9kbi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55948 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0GWNH1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 09:07:27 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimNATxwmz03ob6UoKzjqeKI6DLuA4FjYvmL9kbi@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 27, 2010 at 05:40:23AM +0300, Amir G. wrote:
> Hi Ted,
> 
> There is a lurking bug that needs to be fixed in ext4_free_branches().
> it can cause double freeing of blocks after crash.
> please see bug description below.

Sorry, I've been travelling a lot lately and I'm a bit behind on
processing patch submissions.  I'm going to try to catch up over the
next week or so in preparation for the next merge window.  I'll send
you an update on this (and hopefully your Next3 e2fsprogs patch
submissions, although that doesn't have the same urgency due to
Linus's upcoming merge window for kernel patches) soon.

		       	      	  	 	  - Ted
