From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: remove duplicate remount check for
 JOURNAL_CHECKSUM change
Date: Thu, 12 Feb 2015 23:05:48 -0500
Message-ID: <20150213040548.GD2268@thunk.org>
References: <54DA34BB.8030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39384 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbbBMEFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2015 23:05:50 -0500
Content-Disposition: inline
In-Reply-To: <54DA34BB.8030806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2015 at 10:41:31AM -0600, Eric Sandeen wrote:
> commits c6d3d56d and 6b992ff2 each added the same test for, and
> rejection of, changing journal_checksum during remount.  One suffices.
> 
> While we're at it, remove old comment about the "check" option
> which has been deprecated for some time now.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
