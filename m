From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [RFC][PATCH] Do not accept a new handle when the F.S is frozen
Date: Fri,  6 May 2011 18:20:30 +0300
Message-ID: <1304695231-11335-1-git-send-email-surbhi.palande@canonical.com>
References: <20110504192436.GC6968@quack.suse.cz>
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:51602 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab1EFPUp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2011 11:20:45 -0400
In-Reply-To: <20110504192436.GC6968@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a flag which indicates that the journal is frozen or not and
introduces two new functions jbd2_journal_freeze and jbd2_journal_thaw which
should be called when the F.S freezes and thaws respectively. 
A new handle can only be started now when the barrier count is 0 and when the
journal is not in a frozen state. While the journal is in a frozen state,
trying to start a new handle would put the process on wait queue. Thawing the
journal would wake up all the processes waiting on this wait queue.

I have lightly tested this patch. Sending it here for initial review. Please
do let me know your inputs. Thanks a lot!

Warm Regards,
Surbhi.


