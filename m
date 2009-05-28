From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] e2fsprogs - clean up #ifdef RESOURCE_TRACK
Date: Thu, 28 May 2009 09:37:35 -0400
Message-ID: <20090528133735.GO26625@mit.edu>
References: <b040c32a0905042013y2ff78187kd6b8a0090b2d4d7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ken Chen <kenchen@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59292 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZE1Nho (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 09:37:44 -0400
Content-Disposition: inline
In-Reply-To: <b040c32a0905042013y2ff78187kd6b8a0090b2d4d7a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2009 at 08:13:40PM -0700, Ken Chen wrote:
> Add empty function for init_resource_track() and print_resource_track()
> in the case of ! defined RESOURCE_TRACK, so that we can clean up #ifdef
> throughout e2fsck source.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

Thanks, applied.

					- Ted
