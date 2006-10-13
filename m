From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Fri, 13 Oct 2006 14:56:46 +0400
Message-ID: <m3y7rkeb69.fsf@bzzz.home.net>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org>
	<20061013081002.GR6221@schatzie.adilger.int>
	<20061013104947.GB5519@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org,
	Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:32699 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1751309AbWJMK5D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Oct 2006 06:57:03 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061013104947.GB5519@thunk.org> (Theodore Tso's message of "Fri, 13 Oct 2006 06:49:47 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Theodore Tso (TT) writes:

 TT> I suggest this be tunable by superblock field, and not by a /proc
 TT> tunable.  This is the sort of thing which might be different
 TT> per-filesystem, and the algorithm will be most effective if the
 TT> filesystem always use the same cluster size from the time when it was
 TT> first created.  I'd be happy to assign a superblock field for this
 TT> purpose, and add the appropriate tune2fs support if we have general
 TT> agreement on this point.

that would be good. there is even a stride option to mke2fs?

thanks, Alex
