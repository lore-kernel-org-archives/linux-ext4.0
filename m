Return-Path: <SRS0=q/KL=MW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16560 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbeJJVHm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Oct 2018 17:07:42 -0400
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: jbd2_clear_buffer_revoked_flags() takes a long time
Message-ID: <d2e1ec1a-0d7d-1acb-6887-c55ac30e4a3a@intel.com>
Date: Wed, 10 Oct 2018 16:43:27 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I have a case on a v4.14 kernel where the EXT4 journal commit disables
preemption for 30ms due to jbd2_clear_buffer_revoked_flags().  That in turn
disables preemption on other CPUs as they come to spin waiting for the same
lock.  The side-effect of that is that it periodically blocks high priority
tasks from running.

I see jbd2_clear_buffer_revoked_flags() iterating 32768 times calling
__find_get_block().

Is there any way to make jbd2_clear_buffer_revoked_flags() take less time,
or move its work out from under write_lock(&journal->j_state_lock)?

Or do you have any other suggestions?

Regards
Adrian
