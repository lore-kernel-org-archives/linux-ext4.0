From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsck: journal-replay-only
Date: Wed, 8 Dec 2010 07:42:54 -0500
Message-ID: <A4569757-8D33-4F23-97D7-DF4B0B62CC55@mit.edu>
References: <201011130009.08641.bs_lists@aakef.fastmail.fm> <20101206222714.GB24607@thunk.org> <4CFE54FF.8000600@fastmail.fm> <20101207155939.GE24607@thunk.org> <4CFF4E9C.701@fastmail.fm>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:52771 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab0LHMr7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Dec 2010 07:47:59 -0500
In-Reply-To: <4CFF4E9C.701@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Dec 8, 2010, at 4:23 AM, Bernd Schubert wrote:

> Hmm, still nothing. I poked a bit around in
> http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/ and also don't see
> any recently updated files there.

Are you checking the master or maint branch?   I will be merging the maint branch into master, but I haven't yet since I'm doing some final patch pulls and testing before I cut 1.41.13.

-- Ted


