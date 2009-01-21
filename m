From: David Flater <dflater@nist.gov>
Subject: fs corruption with 2.6.28-ext4-4
Date: Wed, 21 Jan 2009 15:36:03 -0500
Message-ID: <49778733.4030307@nist.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rimp2.nist.gov ([129.6.16.227]:53197 "EHLO smtp.nist.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752273AbZAUUgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jan 2009 15:36:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am guessing that this doesn't belong in bugzilla since it's not a 
mainline kernel I'm talking about.  Sorry if this is still the wrong venue.

On two different computers, I experienced file system corruption after 
upgrading the kernel to 2.6.28-ext4-4 (meaning, mainline 2.6.28 kernel 
with the 2.6.28-ext4-4 patchset from 
http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/ applied).

On Computer #1, an ext4 file system would not mount on reboot.  fsck 
reported that hundreds (all?) of the group descriptors were corrupted.

On Computer #2, the ext2 file system on an external drive became 
corrupted with cross linked blocks.  The file system mounted but the 
kernel soon began reporting problems with it.

In both cases, the corruption seemed to occur at about the time that I 
created a large file (> 4 GiB) using the 2.6.28-ext4-4 kernel.  An older 
computer that I configured with the same kernel and an ext4 file system 
for testing, before the others were upgraded, still has no problems--but 
it has a smaller hard drive and no large files.

I am in the process of reverting to a stable configuration, but please 
accept this experience report for what it is worth.

Thank you,

-- 
David Flater, National Institute of Standards and Technology, U.S.A.


