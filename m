From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext3/jbd: Avoid WARN() messages when failing to write the superblock
Date: Mon, 11 Oct 2010 12:42:29 -0400
Message-ID: <D3CC5904-2064-4307-8798-B89836D71F4C@mit.edu>
References: <20101004193505.GC25624@tux1.beaverton.ibm.com> <4CB327BE.8000003@redhat.com> <20101011151748.GI3830@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, djwong@us.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62548 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888Ab0JKRXR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 13:23:17 -0400
In-Reply-To: <20101011151748.GI3830@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 11, 2010, at 11:17 AM, Jan Kara wrote:
> On Mon 11-10-10 10:05:34, Eric Sandeen wrote:
>> 
>> Probably worth mentioning the ext4 version is:
>> 
>> commit 914258bf2cb22bf4336a1b1d90c551b4b11ca5aa
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date:   Mon Oct 6 21:35:40 2008 -0400
>> 
>>    ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
>> 
>>    This fixes some very common warnings reported by kerneloops.org
>> 
>>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>  Yup. Done. Thanks.

I could have sworn that I had fixed this for both ext3 and ext4.  I guess i didn't track to make sure the ext3 version of the patch made it into mainline.  Thanks, Darrick for fixing this!

-- Ted

