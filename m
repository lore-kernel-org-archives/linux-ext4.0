From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/25] subst: Fix free of uninit pointers
Date: Fri, 16 Sep 2011 18:56:26 -0400
Message-ID: <20110916225626.GQ16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-15-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56176 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab1IPW41 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:56:27 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-15-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:29PM -0500, Eric Sandeen wrote:
> in add_subst(), if the malloc of ent->name fails, we goto fail;
> which will free ent->name (which is null, so OK) but also free
> ent->value (which is uninitialized).  There is no case where
> we must free ent->value on an error (it is allocated last, and
> if it fails it of course doesn't need to be freed) so just
> remove it.
> 
> Also "retval" is only assigned once to the constant ENOMEM,
> so we can just return that explicitly in the failure case.
> 
> Signed-off-by: Eric Saneeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, although I removed the double sign off.  :-)

	 	    	    	- Ted
