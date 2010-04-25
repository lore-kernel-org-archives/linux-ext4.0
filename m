From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Question about e2fsck and HTree
Date: Sun, 25 Apr 2010 18:33:51 -0400
Message-ID: <A4C3C712-08DD-48E0-8537-CA5572F679CF@mit.edu>
References: <z2ne1e08eb01004221243m89a97acei72316abe62daaba@mail.gmail.com> <20100424004544.GM14986@thunk.org> <o2ne1e08eb01004251510h64d7915arb977d7d9a77959d7@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:62508 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab0DYWi6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Apr 2010 18:38:58 -0400
In-Reply-To: <o2ne1e08eb01004251510h64d7915arb977d7d9a77959d7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 25, 2010, at 6:10 PM, Evgeniy Ivanov wrote:
>> 
>> If your implementation of extN don't support HTree, then it's
>> important that when you modify a filesystem you clear the inode's
>> EXT2_INDEX_FL flag.   Then the right thing will happen....
> 
> Thank you very much again :)

Just to be clear, since I typo'ed the above -- when you modify a _directory_ you must clear the directory's EXT2_INDEX_FL flag.

Regards,

-- Ted

