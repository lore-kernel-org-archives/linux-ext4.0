From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2]  ext4: use ext4_grpblk_t more extensively
Date: Tue, 25 Aug 2009 22:40:39 -0400
Message-ID: <20090826024039.GD32712@mit.edu>
References: <4A8C5E5E.70006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52275 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbZHZCkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 22:40:39 -0400
Content-Disposition: inline
In-Reply-To: <4A8C5E5E.70006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 03:19:42PM -0500, Eric Sandeen wrote:
> unsigned  short is potentially too small to track blocks within
> a group; today it is safe due to restrictions in e2fsprogs but
> we have _lo / _hi bits for group blocks with the intent to go
> up to 32 bits, so clean this up now.

Thanks, applied.

					- Ted
