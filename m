From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
 been remounted readonly
Date: Tue, 2 Mar 2010 15:10:36 -0800
Message-ID: <20100302231036.GD11860@mail.oracle.com>
References: <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
 <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
 <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
 <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
 <16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
 <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
 <20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
 <877hq2tyg8.fsf@openvz.org>
 <20100224165646.GL3687@quack.suse.cz>
 <20100302093431.GB5106@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:34500 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0CBXKw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Mar 2010 18:10:52 -0500
Content-Disposition: inline
In-Reply-To: <20100302093431.GB5106@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 02, 2010 at 10:34:31AM +0100, Christoph Hellwig wrote:
> No, there is nothing.  We really do need a multi-stage remount read-only
> process:
> 
>  1) stop any writes from userland, that is opening new files writeable
>  2) stop any periodic writeback from the VM or filesystem-internal
>  3) write out all filesystem data and metadata
>  4) mark the filesystem fully read-only

	If you can code this up in a happily accessible way, we can use
it in ocfs2 to handle some error cases without puking.  That would make
us very happy.  Specifically, we haven't yet taken the time to audit how
we would ensure step (2).

Joel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
