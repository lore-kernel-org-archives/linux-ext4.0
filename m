From: Chris Mason <chris.mason@fusionio.com>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Mon, 1 Apr 2013 11:57:05 -0400
Message-ID: <20130401155705.16754.31446@localhost.localdomain>
References: <87d2uese6t.fsf@openvz.org> <5159A55B.1090302@redhat.com>
 <20130401154541.16754.22860@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48741 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab3DAP5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2013 11:57:10 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id ADB037C0682
	for <linux-ext4@vger.kernel.org>; Mon,  1 Apr 2013 09:57:09 -0600 (MDT)
In-Reply-To: <20130401154541.16754.22860@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Chris Mason (2013-04-01 11:45:41)
> Quoting Eric Sandeen (2013-04-01 11:18:51)
> > On 4/1/13 6:06 AM, Dmitry Monakhov wrote:
> > 
> > > 1)Do we really have to use WRITE_SYNC in case of WB_SYNC_ALL ?
> 
> Yes?  The stuff we wait on should be WRITE_SYNC.
> 
> > 
> > ...
> > 
> > > 2) Why don't we have writepages for non delalloc case ?
> > 
> > ...
> > 
> > I'd add:
> > 
> > 3) Why do we have a "nodelalloc" mount option at all?
> > 
> > but then I thought:
> > 
> > Is it also this bad when using the ext4 driver to run an ext3 fs?
> 
> Quick comparison on a single iodrive:

On the theory that writepages is the problem try echo 1 >
/sys/block/xxx/queue/rotational.  With request merging on here in
nodelalloc mode:

dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc
1073741824 bytes (1.1 GB) copied, 2.53741 s, 423 MB/s

dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc
1073741824 bytes (1.1 GB) copied, 1.37795 s, 779 MB/s

-chris
