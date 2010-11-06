From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: BUG in ext4 with 2.6.37-rc1
Date: Fri, 5 Nov 2010 20:33:05 -0400
Message-ID: <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
References: <20101102202013.GA3861@elliptictech.com> <1288998589.2961.3.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Tony Vroon <tony@linx.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288998589.2961.3.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Nov 5, 2010, at 7:09 PM, Tony Vroon wrote:

> On Tue, 2010-11-02 at 16:20 -0400, Nick Bowler wrote:
>>  ------------[ cut here ]------------
>>  kernel BUG at /scratch_space/linux-2.6/fs/ext4/page-io.c:146!
>>  invalid opcode: 0000 [#1] PREEMPT SMP 
> 
> Confirmed, it's an issue here too.
> I have just hit this one 2 times in a row within 20 minutes. Please CC
> me if you need any fix tested; looks like I'm off to 2.6.26 until this
> is fixed.
> 

Hi, my apologies for not having a lot of time to look at this.  I've been at the Linux Plumber's Conference and Kernel Summit this whole week.

What did you have running which triggered this, and can you try the patch that I sent in this patch, and see if you get the same other BUG_ON?   And if you have the stack trace easily to hand, it would be useful to make sure that part is the same as well.

Many thanks,

-- Ted
