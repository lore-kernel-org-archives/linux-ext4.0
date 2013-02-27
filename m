From: Dave Jones <davej@redhat.com>
Subject: EXT4 corruption on Linus latest tree.
Date: Wed, 27 Feb 2013 10:43:11 -0500
Message-ID: <20130227154311.GA12450@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Built from a pull around midnight EST last night.
(Don't have the git hash, as the source is on the disk that is now inaccessable..)

EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235381: block 152052288: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172228609: block 152051744: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0

This is a 3TB disk which has 1.9TB used.

I can see some files/dirs, but some top level dirs now appear empty.

About to reboot back to a safe kernel and fsck.

	Dave
