From: tytso@mit.edu
Subject: Re: [PATCH] e2fsck: Check for cases where EOFBLOCKS_FL is
 unnecessarily set
Date: Tue, 11 May 2010 20:44:52 -0400
Message-ID: <20100512004452.GY18762@thunk.org>
References: <1273609878-22746-1-git-send-email-tytso@mit.edu>
 <4BE9D4F3.9080003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51340 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab0ELAoy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 May 2010 20:44:54 -0400
Content-Disposition: inline
In-Reply-To: <4BE9D4F3.9080003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 11, 2010 at 05:06:43PM -0500, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > Some kernels will crash if EOFBLOCKS_FL is set when it is it not
> 
> Is there a kernel fix to go with this, then?

There will be; Dmitry sent a patch in the ext4 patch a while back.

http://patchwork.ozlabs.org/patch/50469/

The fix to prevent the crash is tiny.  The rest of the patch I need to
review more carefully....  I'll get to it RSN.

					- Ted
