From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: EXT4 bad block
Date: Thu, 28 Apr 2016 15:10:00 +0100
Message-ID: <20160428151000.13b1438a@lxorguk.ukuu.org.uk>
References: <61AE2E6F29F7AC4182A7076FC3478CDAC217E7@PGSMSX101.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <61AE2E6F29F7AC4182A7076FC3478CDAC217E7@PGSMSX101.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 28 Apr 2016 09:44:16 +0000
"Lay, Kuan Loon" <kuan.loon.lay@intel.com> wrote:

> Hi,
> 
> I encounter random bad block on different file, the message looks like "EXT4-fs error (device mmcblk0p14): ext4_xattr_block_get:298: inode #77: comm (syslogd): bad block 7288". 
> 
> I am using mke2fs 1.43-WIP (18-May-2015) and I saw this message "Suggestion: Use Linux kernel >= 3.18 for improved stability of the metadata and journal checksum features." print out. 
> 
> My current kernel version is 3.14.55, what patch I need to backport to solve the bad block issue?

I think you could start by providing a lot more information about the
platform you see it on, the other messages logged, whether you've run
memtest86 on the machine, whether it is stable if you boot a 4.4 kernel
and so on.

Without that information I doubt anyone can help you with your bug.

Alan
