From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch|rfc][0/3] fix aio+dio+O_SYNC writes
Date: Fri, 27 Jan 2012 16:15:46 -0500
Message-ID: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently, if an AIO/DIO/O_SYNC write is issued, generic_write_sync is
called after the submission of the I/O instead of after the completion.
This can result in flushing the disk cache before the actual write even
gets there!  This patch set attempts to fix that for xfs and ext4.
Comments would be greatly appreciated.

Cheers,
Jeff

[PATCH 1/3] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 3/3] filemap: don't call generic_write_sync for -EIOCBQUEUED
