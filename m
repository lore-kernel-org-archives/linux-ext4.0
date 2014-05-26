From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: prefix printks with JBD2: not JBD:
Date: Mon, 26 May 2014 11:53:38 -0400
Message-ID: <20140526155338.GG22284@thunk.org>
References: <536A652C.7080509@redhat.com>
 <20140526152845.GA23116@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33077 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaEZPxm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 11:53:42 -0400
Content-Disposition: inline
In-Reply-To: <20140526152845.GA23116@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 26, 2014 at 12:28:46PM -0300, Carlos Maiolino wrote:
> I really thought we had already fixed it.
> 
> The patch looks good too, consider it
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

We have fixed this already, and I had noted this already.  See commit
a67c848a8

					- Ted
