From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: protect bb_first_free in ext4_trim_all_free()
 with group lock
Date: Tue, 24 May 2011 18:32:25 -0400
Message-ID: <20110524223225.GJ26055@thunk.org>
References: <alpine.LFD.2.00.1104211135540.4399@dhcp-27-109.brq.redhat.com>
 <1303381596-13758-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, amir73il@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50006 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1EXWcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 18:32:33 -0400
Content-Disposition: inline
In-Reply-To: <1303381596-13758-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 21, 2011 at 12:26:36PM +0200, Lukas Czerner wrote:
> We should protect reading bd_info->bb_first_free with the group lock
> because otherwise we might miss some free blocks. This is not a big deal
> at all, but the change to do right thing is really simple, so lets do
> that.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Added to the ext4 tree, thanks.

						- Ted
