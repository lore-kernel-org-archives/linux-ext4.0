From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unnecessary lock/unlock of
 i_block_reservation_lock
Date: Fri, 3 Apr 2015 00:04:06 -0400
Message-ID: <20150403040406.GH10991@thunk.org>
References: <1427202704-6264-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48548 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbDCEEK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2015 00:04:10 -0400
Content-Disposition: inline
In-Reply-To: <1427202704-6264-1-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 24, 2015 at 02:11:44PM +0100, Maurizio Lombardi wrote:
> This is a leftover of commit 71d4f7d032149b935a26eb3ff85c6c837f3714e1
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Thanks, applied.

					- Ted
