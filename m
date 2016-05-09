From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>
Subject: RE: EXT4 bad block - ext4_xattr_block_get
Date: Mon, 9 May 2016 01:52:18 +0000
Message-ID: <61AE2E6F29F7AC4182A7076FC3478CDAC2D3EB@PGSMSX101.gar.corp.intel.com>
References: <61AE2E6F29F7AC4182A7076FC3478CDAC217E7@PGSMSX101.gar.corp.intel.com>
 <5726F6DB.2010701@pmhahn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Philipp Hahn <pmhahn@pmhahn.de>, "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5726F6DB.2010701@pmhahn.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Not getting the bad block message after disable metadata_csum.

Best Regards,
Lay

> -----Original Message-----
> From: Philipp Hahn [mailto:pmhahn@pmhahn.de]
> Sent: Monday, May 2, 2016 2:43 PM
> To: Lay, Kuan Loon <kuan.loon.lay@intel.com>; tytso@mit.edu;
> adilger.kernel@dilger.ca; linux-ext4@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: EXT4 bad block - ext4_xattr_block_get
> 
> Hello,
> 
> Am 28.04.2016 um 11:44 schrieb Lay, Kuan Loon:
> > I encounter random bad block on different file, the message looks like
> "EXT4-fs error (device mmcblk0p14): ext4_xattr_block_get:298: inode #77:
> comm (syslogd): bad block 7288".
> 
> Interesting; I posted a similar bug report on 2016-04-19 titles  [BUG 4.1.11]
> EXT4-fs error: ext4_xattr_block_get:299 - Remounting filesystem read-only
> 
> I never got a reply.
> 
> > I am using mke2fs 1.43-WIP (18-May-2015) and I saw this message
> "Suggestion: Use Linux kernel >= 3.18 for improved stability of the metadata
> and journal checksum features." print out.
> >
> > My current kernel version is 3.14.55, what patch I need to backport to solve
> the bad block issue?
> 
> That one happened on 4.1.11 on a virtual machine running inside VMware-
> ESX after a hardware change. Last change was to disabled the pvscsi drivers
> again; the system seems to be running fine since 1 week, but the first time it
> took 1 month to notice the corruption, so we're not yet sure that the
> problem is solved.
> 
> Philipp
