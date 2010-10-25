From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4 v. 9] Ext3/Ext4 Batched discard support
Date: Mon, 25 Oct 2010 10:57:56 -0400
Message-ID: <20101025145756.GF16981@thunk.org>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1010111858330.2954@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0JYO57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 10:57:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010111858330.2954@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added the first three patches (all but the ext3 patch) to the
ext4 patch series.  I've desk checked the code; but do you have a
handy-dandy userspace program written to trigger the ioctl?  If so,
could you send it to me so I can do some live fire testing?  Many
thanks!!

						- Ted
