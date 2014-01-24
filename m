From: Ian Nartowicz <claws@nartowicz.co.uk>
Subject: Re: =?utf-8?b?aW5saW5lX2RhdGE=?= feature
Date: Fri, 24 Jan 2014 18:44:18 +0000 (UTC)
Message-ID: <loom.20140124T193846-196@post.gmane.org>
References: <loom.20140122T171340-153@post.gmane.org> <loom.20140124T170451-340@post.gmane.org> <20140124162113.GA11421@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36744 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaAXSoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jan 2014 13:44:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1W6lk9-0002L1-OK
	for linux-ext4@vger.kernel.org; Fri, 24 Jan 2014 19:44:41 +0100
Received: from cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com ([81.103.170.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 19:44:41 +0100
Received: from claws by cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 19:44:41 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso <at> mit.edu> writes:


> 
> Can you send us the fsck transcript?
> 
> Thanks,
> 
> 					- Ted

>From command:
sudo ./e2fsck -yf /dev/sda10 > fsck.out

e2fsck 1.43-WIP (8-Jul-2013)
*** glibc detected *** ./e2fsck: corrupted double-linked list: 0x095989a8 ***
======= Backtrace: =========
[0x80c1ea8]
[0x80c35ba]
[0x80c62b9]
[0x808473e]
======= Memory map: ========
08048000-08148000 r-xp 00000000 08:09 298149    
/data/src/e2fsprogs/e2fsck/e2fsck
08148000-0814d000 rw-p 000ff000 08:09 298149    
/data/src/e2fsprogs/e2fsck/e2fsck
0814d000-0814f000 rw-p 00000000 00:00 0 
09567000-09645000 rw-p 00000000 00:00 0          [heap]
a7400000-a7421000 rw-p 00000000 00:00 0 
a7421000-a7500000 ---p 00000000 00:00 0 
a75c8000-a7609000 rw-p 00000000 00:00 0 
a7609000-a7610000 r--s 00000000 08:05 2226      
/usr/lib/i386-linux-gnu/gconv/gconv-modules.cache
a7610000-a7787000 r--p 00000000 08:05 1909       /usr/lib/locale/locale-
archive
a7787000-a7788000 r-xp 00000000 00:00 0          [vdso]
af7eb000-af80c000 rw-p 00000000 00:00 0          [stack]
Signal (6) SIGABRT si_code=SI_TKILL 
[0x806c375]
[0xa778740c]
[0x80dfd21]
[0x80a91f3]
[0x80bb0b5]
[0x80c1ea8]
[0x80c35ba]
[0x80c62b9]
[0x808473e]


fsck.out:

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Directory inode 16, block #0, offset 60: directory corrupted
Salvage? yes

Entry
've^@^@E^A^@^@^L^@^C^Brss^@F^A^@^@^P^@^F^Bshares^@^@G^A^@^@^L^@^C^Bdht^@M^A
^@^@M-,^A^H^Btorrents^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@
^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@'
in ??? (16) has rec_len of 25441, should be 28637.
Fix? yes

Directory inode 28, block #0, offset 60: directory corrupted
Salvage? yes

Entry '' in ??? (28) has rec_len of 0, should be 3196.
Fix? yes


--iann

