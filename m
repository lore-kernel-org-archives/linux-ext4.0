From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/8] jbd2: gate checksum calculations on crc driver
 presence, not sb flags
Date: Thu, 15 Oct 2015 10:32:25 -0400
Message-ID: <20151015143225.GE17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215422.28872.71133.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Nikolay Borisov <kernel@kyup.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52002 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbbJOOca (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 10:32:30 -0400
Content-Disposition: inline
In-Reply-To: <20151012215422.28872.71133.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:54:22PM -0700, Darrick J. Wong wrote:
> Change the journal's checksum functions to gate on whether or not the
> crc32c driver is loaded, and gate the loading on the superblock bits.
> This prevents a journal crash if someone loads a journal in no-csum
> mode and then randomizes the superblock, thus flipping on the feature
> bits.
> 
> v2: Create a feature-test helper, use it everywhere.
> 
> Tested-By: Nikolay Borisov <kernel@kyup.com>
> Reported-by: Nikolay Borisov <kernel@kyup.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
