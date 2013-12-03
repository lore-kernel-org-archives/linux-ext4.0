From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix use-after-free in ext4_mb_new_blocks
Date: Tue, 3 Dec 2013 18:10:52 -0500
Message-ID: <20131203231052.GC24466@thunk.org>
References: <1384991735-18118-1-git-send-email-jayr@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Junho Ryu <jayr@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36200 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3LCXKz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 18:10:55 -0500
Content-Disposition: inline
In-Reply-To: <1384991735-18118-1-git-send-email-jayr@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 20, 2013 at 03:55:35PM -0800, Junho Ryu wrote:
> ext4_mb_put_pa should hold pa->pa_lock before accessing pa->pa_count.
> While ext4_mb_use_preallocated checks pa->pa_deleted first and then
> increments pa->count later, ext4_mb_put_pa decrements pa->pa_count
> before holding pa->pa_lock and then sets pa->pa_deleted.
> 
> * Free sequence
> ext4_mb_put_pa (1):		atomic_dec_and_test pa->pa_count
> ext4_mb_put_pa (2):		lock pa->pa_lock
> ext4_mb_put_pa (3):			check pa->pa_deleted
> ext4_mb_put_pa (4):			set pa->pa_deleted=1
> ext4_mb_put_pa (5):		unlock pa->pa_lock
> ext4_mb_put_pa (6):		remove pa from a list
> ext4_mb_pa_callback:		free pa
> 
> * Use sequence
> ext4_mb_use_preallocated (1):	iterate over preallocation
> ext4_mb_use_preallocated (2):	lock pa->pa_lock
> ext4_mb_use_preallocated (3):		check pa->pa_deleted
> ext4_mb_use_preallocated (4):		increase pa->pa_count
> ext4_mb_use_preallocated (5):	unlock pa->pa_lock
> ext4_mb_release_context:	access pa
> 
> * Use-after-free sequence
> [initial status]		<pa->pa_deleted = 0, pa_count = 1>
> ext4_mb_use_preallocated (1):	iterate over preallocation
> ext4_mb_use_preallocated (2):	lock pa->pa_lock
> ext4_mb_use_preallocated (3):		check pa->pa_deleted
> ext4_mb_put_pa (1):		atomic_dec_and_test pa->pa_count
> [pa_count decremented]		<pa->pa_deleted = 0, pa_count = 0>
> ext4_mb_use_preallocated (4):		increase pa->pa_count
> [pa_count incremented]		<pa->pa_deleted = 0, pa_count = 1>
> ext4_mb_use_preallocated (5):	unlock pa->pa_lock
> ext4_mb_put_pa (2):		lock pa->pa_lock
> ext4_mb_put_pa (3):			check pa->pa_deleted
> ext4_mb_put_pa (4):			set pa->pa_deleted=1
> [race condition!]		<pa->pa_deleted = 1, pa_count = 1>
> ext4_mb_put_pa (5):		unlock pa->pa_lock
> ext4_mb_put_pa (6):		remove pa from a list
> ext4_mb_pa_callback:		free pa
> ext4_mb_release_context:	access pa
> 
> AddressSanitizer has detected use-after-free in ext4_mb_new_blocks
> Bug report: http://goo.gl/rG1On3
> 
> Signed-off-by: Junho Ryu <jayr@google.com>

Thanks, applied.

						- Ted
