From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Change all super.c messages to print the device
Date: Thu, 4 Jun 2009 14:04:15 -0400
Message-ID: <20090604180415.GC13639@mit.edu>
References: <4A1476D1.9080206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46939 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFDSEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 14:04:21 -0400
Content-Disposition: inline
In-Reply-To: <4A1476D1.9080206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2009 at 04:32:01PM -0500, Eric Sandeen wrote:
> Do the same for ext4 as Andi did for ext3:
> 
> "This patch changes ext4 super.c to include the device name with all 
> warning/error messages, by using a new utility function ext4_msg. 
> It's a rather large patch, but very mechanic. I left debug printks
> alone."

I've added this to the ext4 patch queue.

					- Ted
