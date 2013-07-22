From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: e2fsck running extremely slowly
Date: Sun, 21 Jul 2013 19:35:35 -0700
Message-ID: <51EC9A77.6090109@zytor.com>
References: <51EC6480.6000200@zytor.com> <20130722012929.GA30902@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:38873 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3GVCf6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jul 2013 22:35:58 -0400
In-Reply-To: <20130722012929.GA30902@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/21/2013 06:29 PM, Theodore Ts'o wrote:
> On Sun, Jul 21, 2013 at 03:45:20PM -0700, H. Peter Anvin wrote:
>> I have a large filesystem (14 TB) which suffered a RAID failure which
>> seems to have corrupted some inodes.  Unfortunately as a result there
>> are now a number of inodes with "false extents" which result in a very
>> large number of multiply claimed blocks.
>>
>> I have tried to run e2fsck on this filesystem, and it gets as far as
>> phase 1D, at which point it starts running at a glacial pace.  After 48
>> hours -- most of it sitting at 100% CPU executing no system calls at all
>> -- it claims to have processed a single file out of almost 10000.
> 
> What I usually do when I is to look at the inodes that are corrupted
> in phases 1b, and examine them using debugfs.  If they look insane,
> nuke them using the debugfs clri command.
> 
> Yes, this is horribly manual.  The long term planned solution is that
> the metadata checksum feature will allow us to determine the metadata
> is corrupt, and then e2fsck will know which fs metadata it can trust,
> and which it will have to discard.
>

Manual isn't really practical with almost 10,000 reported inodes...

	-hpa


