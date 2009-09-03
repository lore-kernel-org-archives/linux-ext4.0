From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Thu, 03 Sep 2009 00:12:48 -0500
Message-ID: <4A9F5050.1010702@redhat.com>
References: <12386.1251948115@gamaville.dokosmarshall.org> <4A9F4B57.9080602@redhat.com> <15737.1251954670@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:16590 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZICFMq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 01:12:46 -0400
In-Reply-To: <15737.1251954670@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos wrote:
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>>> Replace all field accesses with calls to access functions.
>>> Most importantly, get rid of the mis-declared group descriptor
>>> pointer which caused the wrong fields to be updated.
>> Not quite sure what you mean by this?  It worked ok for the "old" size ...
>>
> 
> Yes, it worked fine for the old ext2_group_desc structure, but it has no
> hope of working with the ext4_group_desc: the sizes are different, so
> doing bg++ gets it pointing somewhere within the first descriptor, not
> to the beginning of the second. That's how it ended up modifying
> reserved fields.

right.  Ok, I was just confused when you said "mis-declared" - thought 
you meant something was wrong with how bg was set or initialized.

> Sorry about the whitespace problems.  As for the flags, I didn't worry
> too much about how to set them: I figured that once the dust settles,
> we'll follow the proper convention.

sounds good.

Thanks,
-Eric

> Thanks for looking it over and testing too! We'll see whether Justin's
> problem disappears.
> 
> Nick

