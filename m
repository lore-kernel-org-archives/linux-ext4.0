From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Sun, 10 Aug 2008 14:28:28 -0400
Message-ID: <20080810182828.GC15353@mit.edu>
References: <E1KSEkA-00009o-CV@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57468 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbYHJS2b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Aug 2008 14:28:31 -0400
Content-Disposition: inline
In-Reply-To: <E1KSEkA-00009o-CV@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

P.S.  Please excuse the subject line; when I was first writing up the
e-mail, I thought the issue was caused by a bug with how delayed
allocation when under memory pressure interacted with mballoc().
Subsequent tests showed my initial theory was incorrect, and I fixed
the text of my e-mail, but not the subject line....

						- Ted
