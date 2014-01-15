From: Benjamin LaHaise <bcrl@kvack.org>
Subject: ext4: indirect block allocations not sequential in 3.4.67 and 3.11.7
Date: Wed, 15 Jan 2014 14:28:02 -0500
Message-ID: <20140115192802.GK21295@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:44872 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaAOT2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jan 2014 14:28:03 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

As a follow on to my previous issue with ext3, it's looking like the 
indirect block allocator in ext4 is not doing a very good job of making 
block allocations sequential.  On a 1GB test filesystem, I'm getting 
the following allocation results for 10MB files (written out with a single 
10MB write()):

debugfs:  stat testfile.0
Inode: 12   Type: regular    Mode:  0600   Flags: 0x0   Generation: 2584871807
User:     0   Group:     0   Size: 10485760
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 20512
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x52d6de73 -- Wed Jan 15 14:16:03 2014
atime: 0x52d6de27 -- Wed Jan 15 14:14:47 2014
mtime: 0x52d6de73 -- Wed Jan 15 14:16:03 2014
BLOCKS:
(0-11):24576-24587, (IND):8797, (12-1035):24588-25611, (DIND):8798, (IND):8799, 
(1036-2059):25612-26635, (IND):10248, (2060-2559):26636-27135
TOTAL: 2564

debugfs:  stat testfile.1
Inode: 15   Type: regular    Mode:  0600   Flags: 0x0   Generation: 1625569093
User:     0   Group:     0   Size: 10485760
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 20512
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x52d6df0f -- Wed Jan 15 14:18:39 2014
atime: 0x52d6df0f -- Wed Jan 15 14:18:39 2014
mtime: 0x52d6df0f -- Wed Jan 15 14:18:39 2014
BLOCKS:
(0-11):12288-12299, (IND):8787, (12-1035):12300-13323, (DIND):8790, (IND):8791, 
(1036-2059):13324-14347, (IND):8789, (2060-2559):14348-14847
TOTAL: 2564

debugfs:

To give folks an idea about how significant an impact on performance this 
is, using ext4 to mount my ext3 filesystem and create files is resulting 
in a 10-15% reduction in speed when data is being read back into memory.  
I also tested 3.11.7 and see the same poor allocation layout.  I also 
tried turning off delalloc, but there was no change in the layout of the 
data blocks.  Has anyone got any ideas what's going on here?  Cheers,

		-ben
-- 
"Thought is the essence of where you are now."
