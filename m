From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] pu branch: fix more direct fs->group_desc accesses
Date: Mon, 5 Oct 2009 10:56:56 -0400
Message-ID: <20091005145656.GF13512@mit.edu>
References: <4ABC2AEB.4050909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44836 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZJEO5f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Oct 2009 10:57:35 -0400
Content-Disposition: inline
In-Reply-To: <4ABC2AEB.4050909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 24, 2009 at 09:28:59PM -0500, Eric Sandeen wrote:
> This fixes still more direct accesses to fs->group_desc
> fields off a normal array index (group_desc[i]).  Since
> we have variable sized group_desc depending on the group_desc
> size, these all must go through accessor functions.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, I've added it to the pu branch.  (Haven't pushed it out yet
though; still doing some clean up work.  I'll push out a new pu branch
in a day or so.)

					- Ted
