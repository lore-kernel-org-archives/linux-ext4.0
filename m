From: Eric Whitney <enwlinux@gmail.com>
Subject: latest xfstests-bld and nojournal test failures
Date: Tue, 16 Aug 2016 17:45:19 -0400
Message-ID: <20160816214519.GA18888@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35866 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbcHPVlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2016 17:41:45 -0400
Received: by mail-qk0-f195.google.com with SMTP id v123so7514913qkh.3
        for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2016 14:41:44 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI for those running the latest version of the test appliance:

Commit 5e574181f3bf ("test appliance - automate selection of
test/scratch devices") deleted the ^has_journal option from the
MKFS_OPTIONS string in the configuration file for the nojournal test
case.  This leads to failures for generic/034 and 18 other tests in the
nojournal test case;  all of them were prevented from running in the 
previous version of the test appliance by the xfstest function
_require_metadata_journaling().

That function determines whether a test file system supports metadata
journaling by using dumpe2fs to see whether the test or scratch file
system contains a journal.  Use of the noload mount option as
specified by EXT_MOUNT_OPTIONS doesn't affect that determination.

It looks like we'll want to add code to _require_metadata_journaling to
check for use of the noload mount option as well as presence/absence of a
journal.

Eric
