From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: ext3 fsx failures on 2.6.19-rc1
Date: Tue, 10 Oct 2006 09:41:27 -0700
Message-ID: <1160498487.17103.30.camel@dyn9047017100.beaverton.ibm.com>
References: <1160436605.17103.27.camel@dyn9047017100.beaverton.ibm.com>
	 <20061010123059.GJ23622@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: akpm@osdl.org, esandeen@redhat.com,
	ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:54926 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030194AbWJJQlu
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 12:41:50 -0400
To: Jan Kara <jack@suse.cz>
In-Reply-To: <20061010123059.GJ23622@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-10-10 at 14:30 +0200, Jan Kara wrote:
>   Hi,
> 
> > I am having fsx failures on 2.6.19-rc1.
>   :(
> 
> > I don't have any useful information at this time to track it down.
> > I am running 4 copies of fsx (+ fsstress) on a 1k filesystem and
> > one copy of fsx dies.
>   How long does it take? 

Random. It happens any where from 1 hours to 6 hours.

> 
> > fsx-linux[20667]: segfault at 00000000ffffffff rip 00002af0fe031690 rsp
> > 00007fffacc03b88 error 4
> > 
> > READ BAD DATA: offset = 0xa352, size = 0x5fef
> > OFFSET  GOOD    BAD     RANGE
> > 0x df90 0x48e4  0x0000  0x   70
> > operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
>   Hmm, so fsx-linux wrote something and read back zeros. Strange. Do you
> know what that 'segfault' message means? I cannot find it in my copy of
> fsx-linux...
> 
> 							
fsx got a segmentation fault and died. These are the messages in the
dmesg.

Thanks,
Badari

