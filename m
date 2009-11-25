From: tytso@mit.edu
Subject: Re: [PATCH] e2fsprogs: open device writable for trim/discard
Date: Wed, 25 Nov 2009 07:05:56 -0500
Message-ID: <20091125120556.GF14289@thunk.org>
References: <4B031A4F.5080105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41497 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775AbZKYMFz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 07:05:55 -0500
Content-Disposition: inline
In-Reply-To: <4B031A4F.5080105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 17, 2009 at 03:49:03PM -0600, Eric Sandeen wrote:
> Sorry about that, the discard ioctl doesn't actually work
> unless you open the file with write capabilities...

Applied, thanks.

						- Ted
