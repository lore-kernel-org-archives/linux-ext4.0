From: tytso@mit.edu
Subject: Re: [PATCH 2/3] quota: add the option to not fail with EDQUOT in
 block allocation
Date: Thu, 20 May 2010 18:32:29 -0400
Message-ID: <20100520223229.GE16634@thunk.org>
References: <4BBCFD10.3030504@redhat.com>
 <4BBCFE9C.4070302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33703 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab0ETWcb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 18:32:31 -0400
Content-Disposition: inline
In-Reply-To: <4BBCFE9C.4070302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07, 2010 at 04:52:28PM -0500, Eric Sandeen wrote:
> To simplify metadata tracking for delalloc writes, ext4
> will simply claim metadata blocks at allocation time, without
> first speculatively reserving the worst case and then freeing
> what was not used.
> 
> To do this, we need a mechanism to track allocations in
> the quota subsystem, but potentially allow that allocation
> to actually go over quota.
> 
> This patch adds a DQUOT_SPACE_NOFAIL flag and function
> variants for this purpose.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the ext4 patch queue.

					- Ted
