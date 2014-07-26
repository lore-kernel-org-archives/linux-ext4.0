From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/18] e2fsck: fix the various checksum error messages
Date: Sat, 26 Jul 2014 17:09:53 -0400
Message-ID: <20140726210953.GQ6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003428.28334.68886.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58765 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbaGZVJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 17:09:55 -0400
Content-Disposition: inline
In-Reply-To: <20140726003428.28334.68886.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:28PM -0700, Darrick J. Wong wrote:
> Make the "EA block passes checks but fails checksum" message less
> strange, and make the other checksum error messages actually print a
> period at the end of the sentence.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied (with some slight adjustments since I haven't pulled in the
previous patch pending discussion).  I note that there was no need to
adjust any of the expected messages in the e2fsprogs regression tests.

This indicates that we don't have enough (well, any) regression tests
covering the metadata checksum feature.  :-(

						- Ted
