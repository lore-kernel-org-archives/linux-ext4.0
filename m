From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 32/47] e2fsck: read-ahead metadata during passes 1, 2,
 and 4
Date: Wed, 10 Dec 2014 17:00:44 -0500
Message-ID: <20141210220044.GE3370@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215413.883.38863.stgit@birch.djwong.org>
 <20141210202756.GA21938@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50170 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbaLJWAl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Dec 2014 17:00:41 -0500
Content-Disposition: inline
In-Reply-To: <20141210202756.GA21938@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 10, 2014 at 12:27:56PM -0800, Darrick J. Wong wrote:
> FWIW I finally got UAS working in Linux; with that hardware and the default
> readahead size, I see about a 5% reduction in fsck runtime.  The same dock
> plugged into a USB2 port (i.e. BOT) shows about a 2% increase in runtime.

Interesting; what UAS drive were you using?  I've been thinking about
trying to get one to play with.

						- Ted
