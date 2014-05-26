From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix ZERO_RANGE test failure in data journalling
Date: Mon, 26 May 2014 12:29:10 -0400
Message-ID: <20140526162910.GJ22284@thunk.org>
References: <001401cf6e3f$cf49f7c0$6ddde740$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33162 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaEZQ3O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 12:29:14 -0400
Content-Disposition: inline
In-Reply-To: <001401cf6e3f$cf49f7c0$6ddde740$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 13, 2014 at 09:10:55AM +0900, Namjae Jeon wrote:
> xfstests generic/091 is failing when mounting ext4 with data=journal.
> I think that this regression is same problem that occurred prior to collapse
> range issue. So ZERO RANGE also need to call ext4_force_commit as
> collapse range.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Thanks, applied.

						- Ted
