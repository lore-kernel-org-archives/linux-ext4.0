From: "Pranay Kr. Srivastava" <pranjas@gmail.com>
Subject: [PATCH 0/1]ext4: Fix for WARN_ON_ONCE when marking buffer dirty
Date: Thu, 30 Jun 2016 14:12:29 +0300
Message-ID: <1467285150-15977-1-git-send-email-pranjas@gmail.com>
Cc: "Pranay Kr. Srivastava" <pranjas@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


1) Fix WARN_ON_ONCE when marking buffer dirty
   it's possible that a writeback for the super block
   buffer head is triggered after setting the buffer
   uptodate on a buffer write_io_error.

   If however there's an error while writing the buffer
   head then the buffer is cleared from being uptodate.

   If the buffer uptodate is not set while calling
   mark_buffer_dirty, it throws a WARN_ON_ONCE.
   This patch fixes it by locking the buffer while marking
   the buffer uptodate and then marking it dirty while holding
   the buffer head lock.


Pranay Kr. Srivastava (5):
   Fix WARN_ON_ONCE when marking buffer dirty

 fs/ext4/super.c     |  30 +++++-----
 1 files changed, 16 insertions(+), 14 deletions(-)

-- 
1.9.1
