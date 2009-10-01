From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: clean up ext4_dirty_inode()
Date: Thu, 1 Oct 2009 01:22:53 -0400
Message-ID: <20091001052253.GU24383@mit.edu>
References: <6601abe90909171455q50ab5c6dr5b125278d0eae845@mail.gmail.com> <6601abe90909230737s181769b1j968c92984344a40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45660 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZJAFWx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Oct 2009 01:22:53 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90909230737s181769b1j968c92984344a40@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 23, 2009 at 07:37:06AM -0700, Curt Wohlgemuth wrote:
> Ted, any comment on this patch?

Forgot to send you a confirmation, but thanks I've accepted the three
related non-journal patches and they've already been pushed to Linus.
One of them needed to be slightly adjusted to apply with the rest, but
they're all in mainline, as commit ID's d3d1faf, f3dc272, and
830156c/91ac6f4.

						- Ted
