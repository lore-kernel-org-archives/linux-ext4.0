From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Fri, 7 Jan 2011 00:26:13 -0500
Message-ID: <20110107052613.GE2857@thunk.org>
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org>
 <20101228081917.GA1351@bitwizard.nl>
 <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
 <4D1F6244.7050203@redhat.com>
 <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1AGF0U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 00:26:20 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am I missing something?  The kernel stores up to 3k worth of data, on
a 4k block file system.  Whereas e2fsck patch blindly assume 2k worhth
of data regardless of the block size.  The kernel patch looks ok, but
the e2fsprogs patch seems badly broken....

						- Ted
