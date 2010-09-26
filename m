From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Persistant Ext4 error
Date: Sun, 26 Sep 2010 13:51:17 +0100
Message-ID: <20100926125116.GA30683@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I've been seeing regular errors when using Ext4 on an EeePC 900 with a
recent 2.6.36 kernel since a few weeks ago.

[  304.096022] EXT4-fs (sdb2): error count: 5
[  304.096034] EXT4-fs (sdb2): initial error at 1284296437: ext4_lookup:1052: inode 141510
[  304.096042] EXT4-fs (sdb2): last error at 1284300370: htree_dirblock_to_tree:586: inode 129800: block 532439

The error seems to persist no matter how much I fsck the partition
(e2fsck comes from e2fsprogs 1.41.11-1ubuntu2). The distro I am using is
Ubuntu 10.04.

Any ideas on what is causing this and how to fix it?

-- 
Sitsofe | http://sucs.org/~sits/
