From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Wed, 20 May 2009 10:50:22 -0500
Message-ID: <4A1426BE.2010101@redhat.com>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz> <20090519174901.GB9053@mit.edu> <4A130022.6090807@redhat.com> <20090520113047.GC8684@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46266 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZETPud (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 11:50:33 -0400
In-Reply-To: <20090520113047.GC8684@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andi Kleen wrote:
>> I'll do that, unless anyone's already started.
> 
> Fine by me. I haven't done anything on it. Ideally ext2 too.
> 
>> There's a bit of inconsistency in the patch between:
>>
>> ext3_msg(sb, KERN_ERR "message");
>> and
>> ext3_msg(sb, KERN_ERR, "message");
>>
>> just FWIW.
> 
> Where? 
> 
> % grep '^+' ext3-msg  | grep 'KERN[_A-Z]+[^,]'
            ^^ext3_msg^^

> %
> 
> The missing comma would probably not compile.
> 
> -Andi
> 

Just a one I guess:

$ grep '^+' patch | grep 'KERN[_A-Z]\+[ $]'
+			ext3_msg(sb, KERN_ERR "(no)acl options not supported");
+	printk(KERN_INFO "EXT3-FS (%s): ", sb->s_id);

-Eric

