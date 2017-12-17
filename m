From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [QUESTION] jbd2: How identify what kind of metadata is in
 t_buffers
Date: Sun, 17 Dec 2017 18:48:41 -0500
Message-ID: <20171217234841.6i3bw55obssb6afp@thunk.org>
References: <CACFo8TGV98FkYuUpk3Qefb_ki07pa7eoYun6CwXLJLUgNXAD0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Red Swaqz <redswaqz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56024 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756698AbdLQXso (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Dec 2017 18:48:44 -0500
Content-Disposition: inline
In-Reply-To: <CACFo8TGV98FkYuUpk3Qefb_ki07pa7eoYun6CwXLJLUgNXAD0w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 08, 2017 at 02:52:35AM +0900, Red Swaqz wrote:
> Is there any way to identify to what kind of metadata a specific
> t_buffer is related?

There is no way to know --- and it might not even be metadata if
data=journal mode in ext4 is enabled.

What are you trying to do?

						- Ted
