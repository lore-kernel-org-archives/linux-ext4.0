From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is
 detected
Date: Wed, 31 Jul 2013 17:28:13 -0400
Message-ID: <20130731212813.GB8622@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130721143226.GA13473@gmail.com>
 <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
 <20130730003109.GE3648@gmail.com>
 <20130731185243.GB28018@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37575 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533Ab3GaV2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 17:28:20 -0400
Content-Disposition: inline
In-Reply-To: <20130731185243.GB28018@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 31, 2013 at 08:52:43PM +0200, Jan Kara wrote:
>   Well, before spending too much time with this, try finding some study
> (I've read some from Google I think, just I don't have the url at hand) on
> what is the estimated lifetime of a disk after bad sectors start appearing. 

Also worth considering is that error rate profile for flash devices
might be quite different from HDD's.

					- Ted
