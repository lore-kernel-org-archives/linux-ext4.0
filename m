From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix possible use-after-free
 ext4_remove_li_request()
Date: Fri, 20 May 2011 12:03:13 -0400
Message-ID: <20110520160313.GA29282@thunk.org>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
 <1304956630-20384-4-git-send-email-lczerner@redhat.com>
 <4DD57827.9060104@redhat.com>
 <alpine.LFD.2.00.1105201122510.5226@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52683 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934577Ab1ETQDS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 12:03:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105201122510.5226@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas, are you going to be providing a new version of these patch
series or not?  

If you are, could you do it as a separate patch series, instead of
only updating one patch as a reply to the mail thread.  When people do
this, I find it painful since I need to figure out, "ok, I need v2 of
the 1/4 patch, v3 of the 2/4 patch, v4 of the 3/4 patch, and v3 of of
the 4/4 patch.  To provide context, please add version descriptors
after the --- of the patch.  (i.e, "v3 --> v4; fixed commit message")

Also, if we're going to be doing extended review of patches like this,
instead of my just fixing things up when I pull stuff in, people need
to start authoring patches ***much*** sooner.  Doing multiple publish
and review cycles now that the merge window is open really doesn't
work.  One way of solving this in the future is to simply not take any
patch that is first submitted after say, -rc5 or -rc6 until the next
merge window.  But given that some patches didn't *start* getting much
review until 2-3 weeks ago, that wouldn't be entirely fair.

But for the next merge window, if this is going to work, we need
people submitting patches earlier, and people reviewing patches
earlier.

Thanks,

						- Ted
