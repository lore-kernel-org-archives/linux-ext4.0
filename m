From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: ignore differing NEEDS_RECOVERY flag on backup
	sbs
Date: Tue, 7 Apr 2009 13:22:09 -0400
Message-ID: <20090407172209.GB29759@mit.edu>
References: <49281F18.7080404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36231 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbZDGRWQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 13:22:16 -0400
Content-Disposition: inline
In-Reply-To: <49281F18.7080404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 22, 2008 at 09:02:48AM -0600, Eric Sandeen wrote:
> This is for RH bugzilla 471925 -  Complete scan of filesystems expanded online

Applied to the maint branch.

						- Ted
