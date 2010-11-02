From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext3 patches related to uninitialized memory references
Date: Tue, 2 Nov 2010 10:26:27 -0400
Message-ID: <20101102142626.GA25614@thunk.org>
References: <4CCFFC27.3010703@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Roman Borisov <ext-roman.borisov@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41583 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0KBO0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 10:26:42 -0400
Content-Disposition: inline
In-Reply-To: <4CCFFC27.3010703@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 02, 2010 at 02:55:19PM +0300, Roman Borisov wrote:
> Hello,
> 
> Do you have a plans for next patches commitment?
> 
> [PATCH 1/2] ext3: Avoid uninitialized memory references with a
> corrupted htree directory
> http://www.spinics.net/lists/linux-ext4/msg21215.html
> 
> [PATCH 2/2] ext3: Use search_dirblock() in ext3_dx_find_entry()
> http://www.spinics.net/lists/linux-ext4/msg21216.html
> 
> I've found only the same patches for ext4 but not for ext3.

The patches were sent out; I'll resend them to Jan Kara, who has been
maintaining ext3.

						- Ted
