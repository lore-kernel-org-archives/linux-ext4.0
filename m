From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Wed, 3 Oct 2012 14:55:58 -0400
Message-ID: <20121003185558.GB5160@thunk.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53635 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JCT3O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2012 15:29:14 -0400
Content-Disposition: inline
In-Reply-To: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Are you planning on updating the 'ext4: completed_io locking cleanup
V4' patch series, or is this an additional patch that should be tacked
on to it?

Thanks,

						- Ted
