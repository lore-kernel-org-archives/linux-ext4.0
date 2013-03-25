From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Mon, 25 Mar 2013 10:44:08 -0400
Message-ID: <20130325144408.GA4733@thunk.org>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
 <20130324001143.GB4000@thunk.org>
 <alpine.LFD.2.00.1303251051460.23176@localhost>
 <20130325125309.GE26792@thunk.org>
 <alpine.LFD.2.00.1303251420480.23176@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gharm@google.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55681 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406Ab3CYOoQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 10:44:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303251420480.23176@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One of the things I've been thinking we need to add for some time is a
new field to the allocation_request structure which gives a hint to
mballoc about how much space we will eventually need (i.e., if we are
doing a 1GB fallocate, or if we know that we have 256megs worth of
dirty pages that we intend to write out in ext4_da_writepages, we
should tell mballoc that); this is different from how much space we
can actually use (i.e., 32,767 blocks given that's the maximum size we
can add in an uninitialized extents).  If mballoc knew this, it could
reserve that much space as a per-file preallocation.

That might be the easist way to solve this particular issue.

     	      	  	     	- Ted
