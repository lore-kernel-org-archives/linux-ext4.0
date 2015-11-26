From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add "static" to ext4_seq_##name##_fops struct
Date: Thu, 26 Nov 2015 15:52:20 -0500
Message-ID: <20151126205220.GF2632@thunk.org>
References: <CAOjcEBJ10SNdHwHH8mHxF5r3Zvz--UF8H7gdiv7T07T7y9=JuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Xu Cang <cangxumu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53533 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbbKZUwc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Nov 2015 15:52:32 -0500
Content-Disposition: inline
In-Reply-To: <CAOjcEBJ10SNdHwHH8mHxF5r3Zvz--UF8H7gdiv7T07T7y9=JuA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 01, 2015 at 11:23:20AM -0500, Xu Cang wrote:
> to fix sparse warning, add static to ext4_seq_##name##_fops struct.

This is a good patch, but it's missing a Signed-off-by tag.

Please take a look at the directions in the
Documentation/SubmittingPatches file.

Many thanks,

					- Ted
