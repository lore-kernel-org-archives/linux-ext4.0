From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
 fallocate
Date: Mon, 26 May 2014 12:29:00 -0400
Message-ID: <20140526162900.GI22284@thunk.org>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33156 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaEZQ3H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 12:29:07 -0400
Content-Disposition: inline
In-Reply-To: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 13, 2014 at 09:19:17AM +0900, Namjae Jeon wrote:
> Introduce new i_write_mutex to protect new writes from coming while doing
> fallocate operations. Also, get rid of aio_mutex as it is covered by
> i_write_mutex.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Thanks, applied.

					- Ted
