From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: silence warnings in extent status tree debugging
 code
Date: Thu, 20 Feb 2014 16:09:41 -0500
Message-ID: <20140220210941.GA7232@thunk.org>
References: <20140217023041.GA1831@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60576 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbaBTVJr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 16:09:47 -0500
Content-Disposition: inline
In-Reply-To: <20140217023041.GA1831@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 16, 2014 at 09:30:41PM -0500, Eric Whitney wrote:
> Adjust the conversion specifications in a few optionally compiled debug
> messages to match the return type of ext4_es_status().  Also, make a
> couple of minor grammatical message edits while we're at it.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
