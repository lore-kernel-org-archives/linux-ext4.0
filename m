From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: howto downgrade ext4 to ext3
Date: Fri, 18 Sep 2009 13:24:32 -0500
Message-ID: <4AB3D060.2020101@redhat.com>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jehan procaccia <jehan.procaccia@it-sudparis.eu>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242AbZIRSYq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 14:24:46 -0400
In-Reply-To: <20090918175851.GH26991@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Sep 18, 2009 at 04:52:53PM +0200, jehan procaccia wrote:
>> some of you might have followed my miseries about quota support and ext4 ...
>> http://marc.info/?l=linux-ext4&m=125320312905576&w=2
>>
>> Apparently the only sure and secure solution offered to me is to  
>> downgrade my ext4 FS to ext3 :-( .
>> now , is there a procedure to do that ?
> 
> There isn't a procedure to do this, other than backup, reformat, and
> restore.  Sorry about that; it's just one of those things we haven't
> had the resources to create --- and it would not be a trivial task.
> 
> Looking at the problems you had, have you tried simply mounting your
> ext4 filesystem with -o nodelalloc?  The RHEL5.4 kernel doesn't have
> various delalloc patches, and I can certainly understand why Red Hat
> might not be willing to try to engage in backporting all of the
> delalloc fixes to its kernel, but you might be able to use the -o
> nodelalloc feature to simply disable the ext4 feature which appears to
> be causing the problem.  This will cause you to give up some
> performance, but not as much as dropping back to ext3.

Ah, that's a good idea I hadn't thought of, thanks.

Delalloc should be mostly ok in that kernel, but quota doesn't handle 
it.  So dropping quota -or- dropping delalloc should suffice.

OTOH, the -o nodelalloc paths have not gotten a lot of test coverage, so 
caveats apply.

-Eric

> Regards,
> 
> 	     	     	     		 - Ted

