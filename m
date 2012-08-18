From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: don't write superblock when unmounting an ro
 filesystem
Date: Sat, 18 Aug 2012 14:45:04 -0400
Message-ID: <20120818184504.GA5382@thunk.org>
References: <500F1C28.8010800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45502 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2HRSpT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Aug 2012 14:45:19 -0400
Content-Disposition: inline
In-Reply-To: <500F1C28.8010800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, thanks.  I updated the reproduction instructions so that they
wored correctly.  (i.e., by removing the offset, and changing the size
to 1g).

					- Ted
