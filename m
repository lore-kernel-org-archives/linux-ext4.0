From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] blkid: return cached info on either EPERM or
	EACCESS
Date: Tue, 27 May 2008 16:37:30 -0400
Message-ID: <20080527203730.GM7515@mit.edu>
References: <483C60C4.6020509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38242 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758789AbYE0Uh4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2008 16:37:56 -0400
Content-Disposition: inline
In-Reply-To: <483C60C4.6020509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2008 at 02:28:04PM -0500, Eric Sandeen wrote:
> This is for RH bug #448591: blkid command does not work for unprivileged users
> 
> commit 838f133c72a583eae67414368e46ee0303e0a51f made it so that
> any error except EPERM would flush cached filesystem info, but
> if I run blkid as an unprivileged user on F9, I get EACCES not
> EPERM; I think that in this case, as well, we should continue.

This fix is already in e2fsprogs 1.10.....  what version were you
patching against?

							- Ted
