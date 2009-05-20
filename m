From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Wed, 20 May 2009 13:30:47 +0200
Message-ID: <20090520113047.GC8684@one.firstfloor.org>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz> <20090519174901.GB9053@mit.edu> <4A130022.6090807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:50557 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbZETLYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 07:24:48 -0400
Content-Disposition: inline
In-Reply-To: <4A130022.6090807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'll do that, unless anyone's already started.

Fine by me. I haven't done anything on it. Ideally ext2 too.

> 
> There's a bit of inconsistency in the patch between:
> 
> ext3_msg(sb, KERN_ERR "message");
> and
> ext3_msg(sb, KERN_ERR, "message");
> 
> just FWIW.

Where? 

% grep '^+' ext3-msg  | grep 'KERN[_A-Z]+[^,]'
%

The missing comma would probably not compile.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
