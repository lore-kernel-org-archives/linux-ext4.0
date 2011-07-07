From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Mount option "grpid" scheduled for removal?
Date: Thu, 7 Jul 2011 11:14:08 +0200
Message-ID: <20110707091408.GA1102@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from frankvm.xs4all.nl ([83.163.148.79]:51929 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025Ab1GGJVj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2011 05:21:39 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.39.2:

kernel: EXT4-fs (dm-0): Mount option "grpid" will be removed by 2.6.38
kernel: Contact linux-ext4@vger.kernel.org if you think we should keep it.

Is it still scheduled for removal?
Are there technical reasons why it should be removed from an otherwise
excellent backwards compatible filesystem?
Is it also removed from the ext[23] implementation in ext4?

The grpid option is used in a large ext3/ext4 NFS server setup and I'm
aware of the sysv setgid alternative but:

-	Replacing grpid by setgid on directories requires an off-line
	conversion.
-	grpid and setgid on directories are not the same so it can
	break things.

Processes calling chmod() will break group inheritance unless they are
carefully written to only update permission bits. Those programs will
still break when run on an NFS client when the user is not a member of
the group. Repairing the setgid bit requires group membership too.

I'm not saying it's impossible to replace grpid by setgid on directories
but it requires some work and it still can break unexpectedly.

-- 
Frank
