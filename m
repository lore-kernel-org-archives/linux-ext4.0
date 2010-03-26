From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 11:09:59 +0300
Message-ID: <87ljdf7bc8.fsf@openvz.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
	<20100326004738.GJ3145@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41933 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0CZIKG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 04:10:06 -0400
Received: by mail-bw0-f209.google.com with SMTP id 1so1573123bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 01:10:05 -0700 (PDT)
In-Reply-To: <20100326004738.GJ3145@quack.suse.cz> (Jan Kara's message of
	"Fri, 26 Mar 2010 01:47:38 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>   Hi Ted,
>
> On Thu 25-03-10 20:20:18, Theodore Ts'o wrote:
>> This is something I whipped up last night to speed up quotacheck by
>> doing the data collection in e2fsck.  If e2fsck runs and does a full
>> check, it's likely that quotacheck needs to be run as well --- and it's
>> faster if e2fsck does the dirty work of fetching the information since
>> (1) it needs to paw through all of the inodes anyway, and (2) quotacheck
>> has to go through the file system and iterate over the files in an
>> non-optimal order.
>> 
>> What do folks think?  Obviously changes in quotacheck would be required
>> before it could take advantage of these output files, but hopefully that
>> shouldn't be hard...
>> 
>> To use, either use:
>> 
>>    e2fsck -E usrquota_check=/tmp/quota.user,grpquota_check=/tmp/quota.group
>> 
>> or you can edit /etc/e2fsck.conf and add:
>> 
>> [quota]
>> 	directory = /var/e2fsck/quota
>> 
>> I still need to write documentation, update the man pages, and do some
>> polishing, so this is still in a pretty rough state, but I'd appreciate
>> comments.
This is definitely right idea.
>   This is definitely a move in the right direction. I'd be even happier
> if e2fsck would write quota file directly - then we could just make
> quota files hidden inodes, start doing quota accounting immediately
Please excuse my naive question, but is it easy enough to allocate
space during fsck?  If we allow to do this then each fsck will result
in sb-changes because of new tmp quota-file creation/rename/deletion
even if sb and quota is ok.
> on mount and always do quota journaling. That would save us quite some
> trouble in kernel. The only problem with this is that we'd need to pull
> knowledge about quota formats in e2fsck...
>
> 								Honza
