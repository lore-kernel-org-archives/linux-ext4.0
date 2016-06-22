From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2undo: fix endian issues
Date: Tue, 21 Jun 2016 23:11:10 -0400
Message-ID: <20160622031110.GB19684@thunk.org>
References: <fe6468da-e719-2d83-579a-e8bab91c0a99@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52678 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcFVDii (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2016 23:38:38 -0400
Content-Disposition: inline
In-Reply-To: <fe6468da-e719-2d83-579a-e8bab91c0a99@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2016 at 05:51:04PM -0500, Eric Sandeen wrote:
> Two new e2undo issues exist in the latest release on big endian
> machines.
> 
> From sparse check:
> 
> undo_io.c:157:26: warning: invalid assignment: |=
> undo_io.c:157:26:    left side has type restricted __le32
> undo_io.c:157:26:    right side has type int
> undo_io.c:161:26: warning: invalid assignment: &=
> undo_io.c:161:26:    left side has type restricted __le32
> undo_io.c:161:26:    right side has type int
> 
> e2undo.c:211:16: warning: cast to restricted __le64
> e2undo.c:211:16: warning: cast from restricted blk64_t
> e2undo.c:212:16: warning: cast to restricted __le64
> e2undo.c:212:16: warning: cast from restricted blk64_t
> 
> Addresses-RedHat-Bugzilla: 1344636
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
