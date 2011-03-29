From: Tao Ma <tm@tao.ma>
Subject: Re: breaking ext4 to test recovery
Date: Tue, 29 Mar 2011 11:10:39 +0800
Message-ID: <4D914DAF.6060600@tao.ma>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:53492 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754802Ab1C2DKa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 23:10:30 -0400
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/29/2011 10:45 AM, Daniel Taylor wrote:
> I would like to be able to break our ext4 file system
> (specifically corrupt the journal) to be sure that we
> can automatically notice the problem and attempt an
> autonomous fix.
> 
> dumpe2fs tells me the inode, but not, that I can see, the
> blocks where the journal exists (for "dd"ing junk to it).
yeah, AFAICS, you can corrupt it by dd.
As for the journal, normally the journal file uses the inode no 8.
So use
debugfs -R 'stat <8>' /dev/sdx.
Then you will get the disk layout of your journal.
In my box, it looks as:

Inode: 8   Type: regular    Mode:  0600   Flags: 0x80000
Generation: 0    Version: 0x00000000:00000000
User:     0   Group:     0   Size: 33554432
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 65536
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4d86f9ad:00000000 -- Mon Mar 21 15:09:33 2011
 atime: 0x4d86f9ad:00000000 -- Mon Mar 21 15:09:33 2011
 mtime: 0x4d86f9ad:00000000 -- Mon Mar 21 15:09:33 2011
crtime: 0x4d86f9ad:00000000 -- Mon Mar 21 15:09:33 2011
Size of extra inode fields: 28
EXTENTS:
(0-8191): 131072-139263

So see, you get the file's physical block number of that file
131072-139263.
Now corrupt the file as you wish with dd. ;)

Regards,
Tao
