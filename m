From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] * lib/ext2fs/dosio.c (dos_open): don't leak strdup'd
	dev name upon error
Date: Sun, 8 Mar 2009 20:40:18 -0400
Message-ID: <20090309004018.GA9903@mit.edu>
References: <874oyldrrx.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44165 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZCIDPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:43 -0400
Content-Disposition: inline
In-Reply-To: <874oyldrrx.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.

					- Ted

