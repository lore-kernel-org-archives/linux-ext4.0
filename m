From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4 v2] avoid perform unwritten convertion for direct
	IO over non fallocated space
Date: Tue, 3 Nov 2009 21:10:26 -0500
Message-ID: <20091104021026.GG6510@mit.edu>
References: <1255050810.4931.191.camel@mingming-laptop> <6601abe90910200803n1c499ba0w825c59c2f747dce8@mail.gmail.com> <1256165281.6404.4.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38010 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZKDCKY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Nov 2009 21:10:24 -0500
Content-Disposition: inline
In-Reply-To: <1256165281.6404.4.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I fixed up some white space issues, and rewrote the patch description
as follows:

ext4: skip conversion of uninit extents after direct IO if there isn't any

At the end of direct I/O operation, ext4_ext_direct_IO() always called
ext4_convert_unwritten_extents(), regardless of whether there were any
unwritten extents involved in the I/O or not.

This commit adds a state flag so that ext4_ext_direct_IO() only calls
ext4_convert_unwritten_extents() when necessary.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Added to the patch queue.

						- Ted
