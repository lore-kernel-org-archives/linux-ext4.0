From: Eric Whitney <enwlinux@gmail.com>
Subject: e2fsprogs maint branch and metadata_csum option
Date: Mon, 7 Jan 2013 13:03:52 -0500
Message-ID: <20130107180352.GA18255@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34987 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3AGSD5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jan 2013 13:03:57 -0500
Received: by mail-ie0-f181.google.com with SMTP id 16so24310919iea.12
        for <linux-ext4@vger.kernel.org>; Mon, 07 Jan 2013 10:03:56 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In today's concall, I reported an e2fsprogs maint branch test failure I'd
just seen with Ted's xfstests-bld harness.  When running the
metadata_csum,64bit scenario, the result was an immediate mkfs failure with
the following diagnostic: Invalid filesystem option set: metadata_csum,64bit

The metadata_csum option alone was enough to trigger the error.  However, a
look at the maint branch code suggests that it doesn't contain the
metadata_csum support found in the master branch.  I'm guessing my
expectations about the current state of the maint branch were wrong and that
we'll pick up the metadata_csum feature on the merge to master?

If so, there's no bug here - sorry for the noise.

Thanks,
Eric
