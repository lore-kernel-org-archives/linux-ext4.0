From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/5] fallocate system call
Date: Wed, 2 May 2007 18:23:12 +0530
Message-ID: <20070502125312.GA5845@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Chris Wedgwood <cw@f00f.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37322 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993111AbXEBMxO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 May 2007 08:53:14 -0400
Content-Disposition: inline
In-Reply-To: <20070430052559.GA13145@tuatara.stupidest.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:
> On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:
> 
> > For FA_ALLOCATE, it's supposed to change the file size if we
> > allocate past EOF, right?
> 
> I would argue no.  Use truncate for that.

The patch I posted for ext4 *does* change the filesize after
preallocation, if required (i.e. when preallocation is after EOF).
I may have to change that, if we decide on not doing this.

--
Regards,
Amit Arora 
