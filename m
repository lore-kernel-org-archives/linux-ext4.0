From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
Date: Fri, 18 Apr 2008 22:00:54 +0900
Message-ID: <48089B86.5020108@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756010AbYDRNbN@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes

The current JBD is not sufficient for I/O error handling.  It can
cause filesystem corruption.   An example scenario:

1. fail to write a metadata buffer to block B in the journal
2. succeed to write the commit record
3. the system crashes, reboots and mount the filesystem
4. in the recovery phase, succeed to read data from block B
5. write back the read data to the filesystem, but it is a stale
   metadata
6. lose some files and directories!

This scenario is a rare case, but it (temporal I/O error)
can occur.  If we abort the journal between 1. and 2., this
tragedy can be avoided.

This patch set fixes several error handling problems to protect
from filesystem corruption caused by I/O errors.  It has been
done only for JBD and ext3 parts.

This patch is against 2.6.25

[PATCH 1/4] jbd: strictly check for write errors on data buffers
[PATCH 2/4] jbd: ordered data integrity fix
[PATCH 3/4] jbd: abort when failed to log metadata buffers
[PATCH 4/4] jbd: fix error handling for checkpoint io

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center
