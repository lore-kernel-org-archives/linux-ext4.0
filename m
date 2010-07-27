From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_get_blocks references
Date: Tue, 27 Jul 2010 09:47:54 -0400
Message-ID: <20100727134754.GD18966@thunk.org>
References: <4C49FA4E.80109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34271 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab0G0Nrt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 09:47:49 -0400
Content-Disposition: inline
In-Reply-To: <4C49FA4E.80109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 23, 2010 at 03:23:42PM -0500, Eric Sandeen wrote:
> ext4_get_blocks got renamed to ext4_map_blocks, but left stale
> comments and a prototype littered around.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, I've added this patch to the ext4 patch queue.

	     	   	      	     - Ted
