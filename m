From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: jbd2: Fix endian mixing problems in the checksumming code
Date: Wed, 28 Aug 2013 15:06:44 -0400
Message-ID: <20130828190644.GA2161@thunk.org>
References: <20130717020002.GA5785@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50804 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab3H1TGs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 15:06:48 -0400
Content-Disposition: inline
In-Reply-To: <20130717020002.GA5785@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 16, 2013 at 07:00:02PM -0700, Darrick J. Wong wrote:
> In the jbd2 checksumming code, explicitly declare separate variables with
> endianness information so that we don't get confused and screw things up again.
> Also fixes sparse warnings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
