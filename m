From: Philipp Hahn <pmhahn@pmhahn.de>
Subject: Re: EXT4 bad block - ext4_xattr_block_get
Date: Mon, 2 May 2016 08:42:35 +0200
Message-ID: <5726F6DB.2010701@pmhahn.de>
References: <61AE2E6F29F7AC4182A7076FC3478CDAC217E7@PGSMSX101.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:49471 "EHLO parrot.pmhahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbcEBGtC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2016 02:49:02 -0400
In-Reply-To: <61AE2E6F29F7AC4182A7076FC3478CDAC217E7@PGSMSX101.gar.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Am 28.04.2016 um 11:44 schrieb Lay, Kuan Loon:
> I encounter random bad block on different file, the message looks like "EXT4-fs error (device mmcblk0p14): ext4_xattr_block_get:298: inode #77: comm (syslogd): bad block 7288". 

Interesting; I posted a similar bug report on 2016-04-19 titles
 [BUG 4.1.11] EXT4-fs error: ext4_xattr_block_get:299 - Remounting
filesystem read-only

I never got a reply.

> I am using mke2fs 1.43-WIP (18-May-2015) and I saw this message "Suggestion: Use Linux kernel >= 3.18 for improved stability of the metadata and journal checksum features." print out. 
> 
> My current kernel version is 3.14.55, what patch I need to backport to solve the bad block issue?

That one happened on 4.1.11 on a virtual machine running inside
VMware-ESX after a hardware change. Last change was to disabled the
pvscsi drivers again; the system seems to be running fine since 1 week,
but the first time it took 1 month to notice the corruption, so we're
not yet sure that the problem is solved.

Philipp
