From: tytso@mit.edu
Subject: Re: [PATCH 3/5] ext4: Convert to generic reserved quota's space
 management. [V5]
Date: Mon, 14 Dec 2009 09:32:50 -0500
Message-ID: <20091214143250.GB4867@thunk.org>
References: <1260793276-8511-1-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-2-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59182 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZLNOcx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 09:32:53 -0500
Content-Disposition: inline
In-Reply-To: <1260793276-8511-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

BTW, for some reason this patches never made it to the linux-ext4
list.  I'm not sure why; it's listed on the CC list, but it didn't
show up in the linux-ext4 archive, and it didn't show up in the
linux-ext4 patch queue.  Doesn't matter, since Jan will probably need
to push the patch since it's dependant on changes in the generic quota
tree.

						- Ted
