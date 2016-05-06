From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Fix Ubsan error
Date: Thu, 5 May 2016 21:17:49 -0400
Message-ID: <20160506011749.GA31860@thunk.org>
References: <CAA=40849KSFkpG3kkppAruwxfqtQwTw0KsV-LXR5wODdspxDWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Navin P.S" <navinp1912@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52376 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbcEFBRv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 21:17:51 -0400
Content-Disposition: inline
In-Reply-To: <CAA=40849KSFkpG3kkppAruwxfqtQwTw0KsV-LXR5wODdspxDWw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 30, 2016 at 10:29:55PM +0530, Navin P.S wrote:
> Hi,
>   This fixes bugs 114701 and 112161 at bugzilla.kernel.org
>   It is caused due to left shift by a negative value which is undefined.
>   Since these values are not used after a negative shift the change
>   introduces a break.
> 
> Signed-off-by: Navin P.S <navinp1912@gmail.com>

Thanks, I've applied

	http://patchwork.ozlabs.org/patch/599805/
	http://patchwork.ozlabs.org/patch/599804/

To address this problem.

					- Ted
