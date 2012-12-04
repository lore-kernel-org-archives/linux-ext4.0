From: Jiri Slaby <jslaby@suse.cz>
Subject: next: ext4 build failure
Date: Tue, 04 Dec 2012 10:29:00 +0100
Message-ID: <50BDC25C.5020509@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: boyu.mt@taobao.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Sun Dec 2 20:30:52 2012 -0500

    ext4: let fallocate handle inline data correctly

added

static int int ext4_convert_inline_data(struct inode *inode)

       ^^^^^^^

when EXT4_FS_XATTR is unset.

Care to fix that?

thanks,
-- 
js
suse labs
