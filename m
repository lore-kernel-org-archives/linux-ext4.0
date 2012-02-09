From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: clear BH_Delay & BH_Unwritten in
 journal_unmap_buffer
Date: Wed, 8 Feb 2012 22:12:29 -0500
Message-ID: <20120209031229.GI18461@thunk.org>
References: <4F31A098.4050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56360 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab2BIDMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Feb 2012 22:12:32 -0500
Content-Disposition: inline
In-Reply-To: <4F31A098.4050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 07, 2012 at 04:07:20PM -0600, Eric Sandeen wrote:
> journal_unmap_buffer()'s zap_buffer: code clears a lot of buffer head
> state ala discard_buffer(), but does not touch _Delay or _Unwritten
> as discard_buffer() does.
> 
> This can be problematic in some areas of the ext4 code which assume
> that if they have found a buffer marked unwritten or delay, then it's
> a live one.  Perhaps those spots should check whether it is mapped
> as well, but if jbd2 is going to tear down a buffer, let's really
> tear it down completely.
> 
> Without this I get some fsx failures on sub-page-block filesystems
> up until v3.2, at which point 4e96b2dbbf1d7e81f22047a50f862555a6cb87cb
> and 189e868fa8fdca702eb9db9d8afc46b5cb9144c9 make the failures go
> away, because buried within that large change is some more flag
> clearing.  I still think it's worth doing in jbd2, since
> ->invalidatepage leads here directly, and it's the right place
> to clear away these flags.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Cc: stable@vger.kernel.org

Thanks, applied.

					- Ted
