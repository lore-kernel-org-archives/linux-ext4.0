From: tytso@mit.edu
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart
Date: Tue, 25 May 2010 09:55:11 -0400
Message-ID: <20100525135511.GG5556@thunk.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, tytso@mit.ed
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59953 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505Ab0EYNzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 09:55:14 -0400
Content-Disposition: inline
In-Reply-To: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
> If i_data_sem was internally dropped due to transaction restart, it is
> necessary to restart path look-up because extents tree was possibly
> modified by ext4_get_block().
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15827
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

I *think* it would be more efficient to add the additional change:

  	  if (ext4_ext_more_to_rm(path + i)) {

to:

  	  if ((err != -EAGAIN) && ext4_ext_more_to_rm(path + i)) {

in ext4_ext_remove_space() but I would like your opinion...

If we do this optimization I'll probably do it in a separate patch.
It just seems that we're doing a lot of extra work once we fail to
extend the transaction, so it would be good to optimize more of this
out.  It also makes it easier to convince oneself that that all of the
spinning around that happens after returning EAGAIN won't cause any
harm.  After going through the patch carefully I'm pretty sure the
extra work is pointless, but not harmful, but it's better to skip it
entirely if it's not needed.

					 - Ted

