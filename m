From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH RESEND 1/2] ext4: Add inode to the orphan list during
	block allocation failure
Date: Mon, 11 May 2009 07:45:28 -0400
Message-ID: <20090511114528.GA6277@mit.edu>
References: <1241428381-13874-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56762 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZEKLpa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 07:45:30 -0400
Content-Disposition: inline
In-Reply-To: <1241428381-13874-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Did you see the comments I made to the original version of your patch
(e-mail dated April 6, 2008).

The comments can be easily found in the ext4 patchwork website:

    http://patchwork.ozlabs.org/patch/25380/
    http://patchwork.ozlabs.org/patch/25381/

My concern is about stray inodes on the orphan list causing a panic on
umount, and it looks like these patches increases the exposure of this
happening.

						- Ted
