From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 13:21:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904241318460.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de> <20090424120004.GD7949@mit.edu> <49F1B24B.7080308@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbZDXUVq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 16:21:46 -0400
In-Reply-To: <49F1B24B.7080308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Apr 2009, Eric Sandeen wrote:
> Christian, is there anything in dmesg along with it this time?

Yes, as soon as the input/output errors occur, I get:

[34989.160273] EXT4-fs error (device md0): ext4_ext_check_inode: bad header/extent in inode #12042: invalid magic - magic 800, entries 8192, max 5696(0), depth 6144(6144)
[34989.162491] EXT4-fs error (device md0): ext4_ext_check_inode: bad header/extent in inode #12207: invalid magic - magic 42fc, entries 17104, max 62268(0), depth 1283(1283)
[34989.166784] EXT4-fs error (device md0): ext4_ext_check_inode: bad header/extent in inode #12249: invalid magic - magic 42fc, entries 17104, max 62268(0), depth 1283(1283)

I'll try (not) to reproduce this and will use e2fsprogs from the 
beginning.

Christian.
-- 
Bruce Schneier cuts the hair of every man who does not cut his own -- and is
not confused by this fact.
