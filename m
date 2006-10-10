From: Jan Kara <jack@suse.cz>
Subject: Re: ext3 fsx failures on 2.6.19-rc1
Date: Tue, 10 Oct 2006 14:30:59 +0200
Message-ID: <20061010123059.GJ23622@atrey.karlin.mff.cuni.cz>
References: <1160436605.17103.27.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, esandeen@redhat.com,
	ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:26523 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S933015AbWJJMbU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 08:31:20 -0400
To: Badari Pulavarty <pbadari@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1160436605.17103.27.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

> I am having fsx failures on 2.6.19-rc1.
  :(

> I don't have any useful information at this time to track it down.
> I am running 4 copies of fsx (+ fsstress) on a 1k filesystem and
> one copy of fsx dies.
  How long does it take? 

> fsx-linux[20667]: segfault at 00000000ffffffff rip 00002af0fe031690 rsp
> 00007fffacc03b88 error 4
> 
> READ BAD DATA: offset = 0xa352, size = 0x5fef
> OFFSET  GOOD    BAD     RANGE
> 0x df90 0x48e4  0x0000  0x   70
> operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
  Hmm, so fsx-linux wrote something and read back zeros. Strange. Do you
know what that 'segfault' message means? I cannot find it in my copy of
fsx-linux...

								Honza
