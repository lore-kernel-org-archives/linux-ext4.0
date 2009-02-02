From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Fix return value of jbd[2]_start_commit() and ext[34]_sync_fs()
Date: Mon,  2 Feb 2009 18:55:05 +0100
Message-ID: <1233597309-20233-1-git-send-email-jack@suse.cz>
References: <y>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43327 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbZBBRzN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Feb 2009 12:55:13 -0500
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Here are patches changing journal_start_commit() and it's JBD2 equivalent to
have more sensible meaning of a return value and patches changing
ext3_sync_fs() and ext4_sync_fs() back to original state (wrt journal
flushing).

									Honza
