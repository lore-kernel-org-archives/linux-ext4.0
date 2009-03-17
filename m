From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Fix bugs and possible data corruption if blocksize < pagesize
Date: Tue, 17 Mar 2009 18:33:51 +0100
Message-ID: <1237311235-13623-1-git-send-email-jack@suse.cz>
References: <n>
Cc: linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:59680 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZCQST7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 14:19:59 -0400
In-Reply-To: <n>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  lately, I've been tracking some problems with ext3 reported by HP on ia64 and
this is what I came with. The first three patches fix real bugs - the first two
fix bugs in ext3 leading to false reports of EIO errors from JBD and aborted
journal, the third patch fixes a bug in block_write_full_page() which can
possibly lead to data corruption.
  With these patches, don't see the data corruption I was able to reproduce
with fsx-linux under UML. I'm not yet sure whether all the problems HP reported
are gone (they're testing now) but since this seems to be a nasty problem I'm
posting earlier rather than later. Please someone have a look whether my fix
and analysis looks sane. Thanks.

									Honza
