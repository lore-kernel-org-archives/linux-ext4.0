From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 09 May 2007 12:02:36 -0500
Message-ID: <4641FEAC.9090203@redhat.com>
References: <20070503140804.463b20e1@naruto>	<463B4A1B.4070201@bull.net>	<20070507111952.7868bc1c@gara>	<4641BBB7.8020904@bull.net>	<20070509085547.4785bf7d@gara>	<4641E13D.906@bull.net>	<4641E708.1090109@redhat.com> <20070509113428.760f453a@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXEIRFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2007 13:05:19 -0400
In-Reply-To: <20070509113428.760f453a@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jose R. Santos wrote:
> On Wed, 09 May 2007 10:21:44 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:

>> Jose, you mentioned that some blocks are still "unsigned long" on
>> 32-bits... they shouldn't be, the LBD work should have fixed all those
>> long ago.  But there is still the 16TB page cache limit in force.
> 
> Found this in mke2fs.c
>                 unsigned long blocks = EXT2_BLOCKS_COUNT(fs->super);
>                 unsigned long start;

Ah, ok, I thought you were talking about kernelspace...

yeah, that looks like a problem.  And it's from a patch called
"use_64bit_block_numbers"  *grin*

there are a few related typedefs in e2fsprogs, such as blk_t, which is __u64

should we be using those for block number containers?

-Eric
