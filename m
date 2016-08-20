From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] kvm-xfstests: update command line help
Date: Sat, 20 Aug 2016 18:19:58 -0400
Message-ID: <20160820221958.GA855@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-4-git-send-email-dmonakhov@openvz.org>
 <20160819134238.GG10888@thunk.org>
 <878tvs7tpn.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48712 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbcHTWUE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 Aug 2016 18:20:04 -0400
Content-Disposition: inline
In-Reply-To: <878tvs7tpn.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've improved the usage commands for gen-image and gce-xfstests
somewhat.  It's roughly based on your patch, but as discussed, there
are certain options and commands which I don't want to include in the
usage messages either because they rely on out-of-tree xfstests
patches, or they are too specialized to be of interest to most users.

Cheers,

					- Ted
