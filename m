From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fielfrag: fix it so it works in the bmap fallback case.
Date: Sat, 18 Jul 2009 09:57:42 -0400
Message-ID: <20090718135742.GA28587@mit.edu>
References: <4A5E3A9F.1040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46680 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZGRN5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 09:57:45 -0400
Content-Disposition: inline
In-Reply-To: <4A5E3A9F.1040809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 15, 2009 at 03:22:55PM -0500, Eric Sandeen wrote:
> It looks like some debugging crept in?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
