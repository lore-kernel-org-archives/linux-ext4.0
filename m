From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 0/2] jbd[2]: fix long-standing data corruption bug
Date: Sat, 15 Mar 2008 18:49:43 +0000
Message-ID: <1205606985-22645-1-git-send-email-duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, duaneg@dghda.com
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2833 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYCOStu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2008 14:49:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It seems we have a very long-standing typo in the journal replay magic number
unescaping code that basically means it will cause data corruption if we ever
actually use it. I think this is a candidate for the stable tree.

The following script, run on an FS mounted with data=journal, may be helpful in
reproducing and testing this bug:

#!/bin/bash

rm -rf test-dir && mkdir test-dir

for (( i=0; i != 100; i++ )); do
	printf "\xc0\x3b\x39\x98" > test-dir/$RANDOM
done

while /bin/true; do
	printf "\xc0\x3b\x39\x98" > test-dir/$RANDOM
	rm test-dir/`ls test-dir | sort -R | head -n1`
done
