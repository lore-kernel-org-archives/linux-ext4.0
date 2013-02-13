From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/8] xfstests: Stress tests improments v3
Date: Wed, 13 Feb 2013 12:49:55 +0400
Message-ID: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:32335 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab3BMIub (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 03:50:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is third version of the patch series, previous version
can be found here: http://oss.sgi.com/archives/xfs/2012-09/msg00328.html

xfstests-add-fio-requirement-V2
xfstests-get-rid-of-hardcoded-sbin-mkfs
xfstest-add-configurable-load-factors
xfstest-allow-fsstress-to-use-load-factor-where-appr
run-check-to-common_rc
add-fallocate-truncate-vs-AIO-DIO-stress-test
add-fallocate-punch_hole-vs-AIO-DIO-stress-test
add-defragmentation-stress-tests-for-ext4

Changes since V2

Mostly code style cleanups accodring to Dave's comments
- add _scale_fsstress_args function
- move run_check function to common.rc
- Add more comments
- split combined e4defrag testcase in to disicated tescases.
