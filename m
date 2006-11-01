From: "Wolber, Richard C" <richard.c.wolber@boeing.com>
Subject: RE: Shred mount option for ext4?
Date: Wed, 1 Nov 2006 08:57:37 -0800
Message-ID: <8C7C41A176AC0B468BEFB2EFD9BDAB9902426639@XCH-NW-5V2.nw.nos.boeing.com>
References: <20061101161700.GA5212@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Erik Mouw" <erik@harddisk-recovery.com>,
	"Samuel Tardieu" <sam@rfc1149.net>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:48792 "EHLO
	slb-smtpout-01.ns.cs.boeing.com") by vger.kernel.org with ESMTP
	id S1752222AbWKAQ66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2006 11:58:58 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20061101161700.GA5212@schatzie.adilger.int>
To: "Andreas Dilger" <adilger@clusterfs.com>,
	"Nikolai Joukov" <kolya@cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wednesday, November 01, 2006 8:17 AM Andreas Dilger Wrote:
> 
> Did anyone discuss doing this with crypto instead of actually 
> overwriting the whole file?  It would be pretty easy to store 
> a per-file crypto key in each inode as an EA, then to 
> "delete" the file all that would be needed would be to erase 
> the key in a secure matter (which is a great deal easier 
> because inodes don't move around on disk).

If it's cheap to delete the keys, it's also cheap to harvest 
the keys. A per file crypto-key lowers the barrier to entry.

This is Schneier 101.


..Chuck..
