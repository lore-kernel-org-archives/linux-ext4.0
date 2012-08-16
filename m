From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 0/8] remove lock and unlock super
Date: Thu, 16 Aug 2012 11:59:19 +0200
Message-ID: <502CC477.4060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I'm trying to remove the functions lock_super/unlock_super and to push 
the lock into each single fs. Currently these fs use these functions: 
ext3, ext4, fat, hpfs, exofs, sysv, ufs. At the moment I used the more 
conservative approach, I created a new mutex s_lock in the private sb 
info for each fs, so nothing change but a couple of notes:

1) exofs/hpfs: they use lock_super only in one function so the lock 
seems completely not needed and I removed it, do you see collateral effect?

2) fat/ufs: they have already got functions to lock the fs with a mutex, 
I don't know at the moment if a general review of the code can give us 
the possibility to "merge" the locks.

Bugs, comments, review are welcome especially from fs maintainers. Maybe 
this work can be a first cleaning, after that each fs can adjust its 
lock policy.

The patch is against 3.6-rc1.

Marco
