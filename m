From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix possible use-after-free
 ext4_remove_li_request()
Date: Fri, 20 May 2011 13:47:19 -0400
Message-ID: <20110520174719.GD29282@thunk.org>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
 <1304956630-20384-4-git-send-email-lczerner@redhat.com>
 <4DD57827.9060104@redhat.com>
 <alpine.LFD.2.00.1105201122510.5226@dhcp-27-109.brq.redhat.com>
 <20110520160313.GA29282@thunk.org>
 <4DD692D5.6010400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37694 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab1ETRrV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 13:47:21 -0400
Content-Disposition: inline
In-Reply-To: <4DD692D5.6010400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 20, 2011 at 11:12:05AM -0500, Eric Sandeen wrote:
> 
> But skipping thorough review simply because the window is open now
> doesn't make sense to me.

Sure, but adding a 24-hour turnaround for at least simple fix ups
(commit descriptions, comments, white space, etc) doesn't make a lot
of sense either.

						- Ted
