From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 14:15:39 +0300
Message-ID: <87y6hfibac.fsf@openvz.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
	<20100326004738.GJ3145@quack.suse.cz>
	<20100326033824.GC21658@thunk.org>
	<9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
	<87hbo37ay3.fsf@openvz.org> <20100326105733.GC3055@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <andreas.dilger@oracle.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56167 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0CZLPr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 07:15:47 -0400
Received: by bwz1 with SMTP id 1so1692280bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 04:15:45 -0700 (PDT)
In-Reply-To: <20100326105733.GC3055@quack.suse.cz> (Jan Kara's message of
	"Fri, 26 Mar 2010 11:57:33 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Fri 26-03-10 11:18:28, Dmitry Monakhov wrote:
>> > If there isn't a reason to continue using unjournaled quota (i.e. it
>> > doesn't break to just move to journaled quota everywhere), then these
>> > could just become aliases for the journaled quota implementation.  The
>> > other alternative is to deprecate these options in the next kernel and
>> > have it print out a warning on the console to tell the user to switch
>> > over to the journaled version.
>> The only reason to not use journalled quota by default is the currently
>> it is a bit slower than unjournalled variant.
>> This is because each quota change result in synchronous quotafile 
>> update in per-sb-page-cache. And this update is protected by i_mutex.
>> and dqio_mutex. It may be fixed easily. I've sent a RFC patch two
>> month ago. I'll update it and will submit it this weekend. 
>   Well, there is also some overhead caused by more IO we have to do for
> quota journaling and that is essentially unavoidable. But still I believe
> we should transition people to journaled quotas...
Agree. IO overhead due to journalled quota is almost invisible.
And it must be enabled by default after most annoying lock contention
will be resolved.

BTW. i've had bad news. Seems what journalled was broken recently.
Right after i've wrote the first letter. i've started to update the
quota-speedup patch. And during testing phase i've found that
journalled quota is inconsistent after power-failure(w/o my patches).
I've tested ext4.git/for-next branch
Currently i'm investing the issue.
>
> 								Honza
