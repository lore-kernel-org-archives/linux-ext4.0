From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 11:43:10 -0500
Message-ID: <4A9EA09E.10509@redhat.com>
References: <4A9D9574.3010606@redhat.com>	 <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbZIBQnN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 12:43:13 -0400
In-Reply-To: <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard wrote:
> On Tue, Sep 1, 2009 at 10:59 PM, Andreas Dilger<adilger@sun.com> wrote:
>> On Sep 01, 2009  16:43 -0500, Eric Sandeen wrote:
>>> ext2fs_open2() was only looking at s_blocks_count, and
>>> when it wrapped to a low number, it was failing the test of:
>>>
>>>   fs->super->s_first_data_block >= fs->super->s_blocks_count
>>>
>>> which made the superblock look corrupt.
>> Is this the source of the "e2fsck is finding bad checksums" problem?
> 
> I applied this earlier today, and it didn't appear to help in my test case.
> 
> -Justin

Nah, didn't expect it to, but I'm working towards that.  Just have to
whack down the bugs between where I am, and your bug ;)

-Eric
