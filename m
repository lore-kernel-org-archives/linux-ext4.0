From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: fix cross compilation problem
Date: Mon, 5 May 2014 21:15:26 -0400
Message-ID: <20140506011526.GA17586@thunk.org>
References: <1394676087-2624-1-git-send-email-Qi.Chen@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chen Qi <Qi.Chen@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51009 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933611AbaEFBP2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 21:15:28 -0400
Content-Disposition: inline
In-Reply-To: <1394676087-2624-1-git-send-email-Qi.Chen@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2014 at 10:01:27AM +0800, Chen Qi wrote:
> The checking of types in parse-types.sh doesn't make much sense in a
> cross-compilation environment, because the generated binary is executed
> on build machine.
> 
> So even if asm_types.h has got correct statements for types, it's possible
> that the generated binary will report an error. Because these types are for
> the target machine.
> 
> Signed-off-by: Chen Qi <Qi.Chen@windriver.com>

Applied, thanks.

					- Ted
