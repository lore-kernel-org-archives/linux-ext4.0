From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Date: Tue, 06 Jul 2010 14:40:23 +0100
Message-ID: <29431.1278423623@redhat.com>
References: <20100706001032.GA25018@dastard> <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0GFNkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 09:40:42 -0400
In-Reply-To: <20100706001032.GA25018@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner <david@fromorbit.com> wrote:

> Further, it opens up the possibility that further down the track
> someone modifies S_* flag values (say when adding some XFS
> functionality) and corrupts extN filesystems all over the place.
> There isn't even compiler guards to catch someone modifying the S_*
> flags in a way that makes it incompatible with the extN on-disk
> definitions.

That occurred to me after I sent the patch.  I can add some preprocessor guards
for this.

David
