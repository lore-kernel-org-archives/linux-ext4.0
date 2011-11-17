From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/2] debugfs: add filefrag command
Date: Thu, 17 Nov 2011 16:27:39 -0500
Message-ID: <DBBE60E4-D215-459C-BBBF-59666069D462@mit.edu>
References: <1321564364-22803-1-git-send-email-tytso@mit.edu> <4EC57A6A.80306@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:59660 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898Ab1KQV1g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Nov 2011 16:27:36 -0500
In-Reply-To: <4EC57A6A.80306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 17, 2011, at 4:19 PM, Eric Sandeen wrote:

> On 11/17/11 3:12 PM, Theodore Ts'o wrote:
>> Add the ability to report on the fragmentation of a file on a file
>> system opened using debugfs.
>> 
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>> debugfs/Makefile.in      |    8 +-
>> debugfs/debug_cmds.ct    |    3 +
>> debugfs/debugfs.8.in     |   21 +++
>> debugfs/debugfs.h        |    1 +
>> debugfs/filefrag.c       |  324 ++++++++++++++++++++++++++++++++++++++++++++++
> 
> Is it possible to share any of ^^^ that code ^^^ with misc/filefrag.c somehow?

Well, the debugs code accesses the file system directly; I thought about creating glue code that created an interface similar to FIEMAP ioctl, but the glue code ends up being more than the code to do just do the fragmentation calculation.

-- Ted

