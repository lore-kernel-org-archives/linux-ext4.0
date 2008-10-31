From: Theodore Tso <tytso@mit.edu>
Subject: Re: Wrapping Ext4 credential accesses
Date: Fri, 31 Oct 2008 10:10:46 -0400
Message-ID: <20081031141046.GB17651@mit.edu>
References: <11242.1225450036@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33563 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752799AbYJaOKt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 10:10:49 -0400
Content-Disposition: inline
In-Reply-To: <11242.1225450036@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 31, 2008 at 10:47:16AM +0000, David Howells wrote:
> 
> Can you add the attached patch into the ext4 tree please?  It wraps credential
> accesses (current->fsuid -> current_fsuid() for example) so that moving to a
> detached cred structure is easier.  The prerequisite patch has been upstream
> for a while.  Hopefully we can get Linus to take the rest of the patches in
> the next merge window.

Sure!  You're not looking for this to be merged before the next merge
window, correct?  So it will be Ok if I carry this patch and push this
at the next merge window?

								- Ted

