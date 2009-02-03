From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: htree indexing and 64-bit file systems
Date: Tue, 3 Feb 2009 17:22:02 -0500
Message-ID: <20090203222202.GK20654@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZBCW0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 17:26:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've just been ignoring htree indexing for now, but the regression
failure in Ted's rebased 64bit tree looks suspiciously htree-related.

What's the interaction between htree and 64 bit file systems?  What
needs to change, if anything?

-VAL
