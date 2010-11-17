From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: missing unlock in ext4_clear_request_list()
Date: Wed, 17 Nov 2010 14:01:25 -0500
Message-ID: <20101117190125.GJ3290@thunk.org>
References: <20101117050732.GB31724@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dan Carpenter <error27@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-ja
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55161 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935040Ab0KQTBb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 14:01:31 -0500
Content-Disposition: inline
In-Reply-To: <20101117050732.GB31724@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 17, 2010 at 08:07:32AM +0300, Dan Carpenter wrote:
> If the the li_request_list was empty then it returned with the lock
> held.  Instead of adding a "goto unlock" I just removed that special
> case and let it go past the empty list_for_each_safe().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Nice catch.  Thanks, I've grabbed this and put it into the ext4 patch
queue and will be pushing it to Linus ASAP.

					- Ted
