From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Fri, 15 Jan 2010 13:52:45 -0600
Message-ID: <4B50C78D.2000807@redhat.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab0AOTwu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jan 2010 14:52:50 -0500
In-Reply-To: <1263583812-21355-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> I've worked with Jiaying to ready this patch for submission.
> 
> It's currently a mount option for maximum safety, but after we do some
> benchmarking to make sure it doesn't degrade performance for buffered
> writes, we may want to make this the default.  Once really nice side
> effect of this patch is that it effectively gives us "guarded mode" by
> default, since the blocks are marked as uninitialized and only converted
> to be initialized when the I/O has completed for both buffered and
> direct I/O writes now.  This means that we could possibly change the
> default mode to be data=writeback if the extents feature is enabled,
> since data=ordered would only needed for safety when writing new
> old-style indirect blocks.

At least as far as that last bit goes, simply having the extents
feature is not sufficient; we allow both formats of files to exist
on a filesystem with the extents feature turned on.

As to the general idea I'll have to give it more thought. :)

-Eric

