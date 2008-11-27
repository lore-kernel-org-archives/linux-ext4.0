From: Solofo.Ramangalahy@bull.net
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Thu, 27 Nov 2008 10:30:31 +0100
Message-ID: <18734.26807.381726.82414@frecb006361.adech.frec.bull.fr>
References: <20081121102309.182113793@bull.net>
	<20081121102309.507553245@bull.net>
	<20081127045047.GF14101@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58348 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYK0Jaf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2008 04:30:35 -0500
In-Reply-To: <20081127045047.GF14101@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Theodore Tso writes:
 > 2) You need to set the flag *before* you calculate the block group
 > checksum, not afterwards.

Sorry about this. I forgot to do the quilt refresh (and check that the
code I submit is the same that the code I run).

 > 1) You didn't include a Developer's Certification of Origin (i.e., a
 > "Signed-off-by" header).  Since this is a one line patch, and it seems
 > pretty clear your intention is to submit this to Linus,

This was really an RFC, as you also pointed out.
Regarding this patch, the discussion raised the question of whether
EXT4_BG_INODE_UNINIT or EXT4_BG_ITABLE_UNINIT would be more coherent
than EXT4_BG_INODE_ZEROED wrt. EXT4_BG_INODE_UNINIT and
EXT4_BG_BLOCK_UNINIT.
This was also used as an example for the discussion about doing the
initialization outside of an init thread (which turned up not to be a
good idea).
This is also the first use of EXT4_BG_INODE_ZEROED in the kernel, so
an occasion to revisit the name. 
I did not look carefully in the progs (EXT2_BG_INODE_ZEROED) to see if
it is desirable and easy to change it. cscope indicates that it may be
easy (4 instances).

 > So the corrected patch should look like this....

Thank you, that's settled then,
-- 
solofo
