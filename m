From: Theodore Tso <tytso@mit.edu>
Subject: Re: Some 64-bit tests
Date: Wed, 10 Jun 2009 14:13:20 -0400
Message-ID: <20090610181320.GA6953@mit.edu>
References: <18887.1244469441@gamaville.dokosmarshall.org> <20090608201037.GB23723@skywalker> <14597.1244517228@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54760 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465AbZFJVLd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2009 17:11:33 -0400
Content-Disposition: inline
In-Reply-To: <14597.1244517228@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 08, 2009 at 11:13:48PM -0400, Nick Dokos wrote:
> 
> I tried this on top of 2.6.30-rc8 and I hit a couple of BUGs, one in pdflush
> and the other in the Lustre teest program (liverfs):
> 
> Jun  8 22:49:13 shifter kernel: ------------[ cut here ]------------
> Jun  8 22:49:13 shifter kernel: kernel BUG at fs/ext4/mballoc.c:3245!
> Jun  8 22:49:13 shifter kernel: invalid opcode: 0000 [#1] SMP 

Hmmm, that would be the BUG_ON check:

     BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));

						- Ted
