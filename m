From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 11:37:09 -0400
Message-ID: <20110607153709.GA30037@thunk.org>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
 <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
 <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
 <4DECF2D5.7050408@redhat.com>
 <alpine.LFD.2.00.1106061755260.3934@dhcp-27-109.brq.redhat.com>
 <20110606204028.GD20818@thunk.org>
 <4DEE2EB6.2050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"Amir G." <amir73il@users.sourceforge.net>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59873 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab1FGPhO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 11:37:14 -0400
Content-Disposition: inline
In-Reply-To: <4DEE2EB6.2050901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 07, 2011 at 09:59:18AM -0400, Ric Wheeler wrote:
> 
> Can we argue that the user base that uses these ancient options can
> simply continue to use them in ext3 and use that fig leaf to kill
> them in ext4 going forwards?

Unfortunately, I marking it as deprecated, with a printk that it would
go away, and someone complained saying they depended on it.  So they
were using ext4, and according to the standard which Linus set out, we
have to keep it around.  Honestly, the whole minixdf really isn't
worth worrying about...

     	      	 	       	    	      - Ted
