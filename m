From: Valerie Aurora <vaurora@redhat.com>
Subject: Fix device too big bug in mainline?
Date: Thu, 30 Jul 2009 17:53:02 -0400
Message-ID: <20090730215302.GA31141@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZG3VxF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jul 2009 17:53:05 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Currently, e2fsprogs will fail to create a file system if the
underlying device is "too big" - even if we specify a number of blocks
to use that is in range:

https://bugzilla.redhat.com/show_bug.cgi?id=485236

This is fixed in the current pu branch, but more as a side effect of
an enormous 64-bit rewrite.

Ted, any plans to pull this into mainline?

-VAL
