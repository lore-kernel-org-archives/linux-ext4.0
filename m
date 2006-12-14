From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] [patch 2/3] change attribute for ext4: ext4 specific code
Date: Thu, 14 Dec 2006 11:03:07 -0500
Message-ID: <20061214160307.GE9079@thunk.org>
References: <456DD75A.2010700@bull.net> <20061206214934.GA4551@schatzie.adilger.int> <45803906.5070307@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41331 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860AbWLNQfS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Dec 2006 11:35:18 -0500
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Content-Disposition: inline
In-Reply-To: <45803906.5070307@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 13, 2006 at 06:31:50PM +0100, Cordenner jean noel wrote:

There was discussion on yesterday's call about whether or not 32-bit
was enough for NFSv4, or whether it also requried 64-bits of change
notification in the RFC's.  So one of the questions is whether this is
something that would justify requiring 64-bits --- and if so, maybe we
need to require that big inodes be used and store the entire 64-bit
value beyond 128 bytes.  This would mean that NFSv4 cache management
couldn't be fully implemented without big inodes, or we'd have to make
do by using the inode ctime as a partial substitute.

What do you think?

						- Ted
