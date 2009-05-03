From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] cleanup whitespace in problem.c and problem.h
Date: Sat, 2 May 2009 21:06:34 -0400
Message-ID: <20090503010634.GD22191@mit.edu>
References: <20090428185907.GS3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42812 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZECBGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 21:06:39 -0400
Content-Disposition: inline
In-Reply-To: <20090428185907.GS3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 12:59:07PM -0600, Andreas Dilger wrote:
> Cleanup whitespace in the problem.h and problem.c files.  Removes a
> bunch of places where tabs follow spaces, whitespace on empty lines, etc.
> I didn't reformat the indenting of the entire problem.h error codes,
> but there is some room for doing this...
> 
> Signed-off-by: Andreas Dilger <adilger@sun.com>

Thanks, applied.

					- Ted
