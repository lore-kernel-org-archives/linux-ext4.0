From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 1/2] ext3: add an option to control error handling on file
    data
Date: Thu, 31 Jul 2008 15:03:12 +0900
Message-ID: <489155A0.2070208@hitachi.com>
References: <488FD756.9060106@hitachi.com>
    <170fa0d20807300814o7741859eu8ad5d5b3b95e401c@mail.gmail.com>
    <20080730211703.GZ3342@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@gmail.com>, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	tglx@linutronix.de, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50923 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYGaGDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 02:03:22 -0400
In-Reply-To: <20080730211703.GZ3342@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 30, 2008  11:14 -0400, Mike Snitzer wrote:
> 
>>On Tue, Jul 29, 2008 at 10:52 PM, Hidehiro Kawai
>><hidehiro.kawai.ez@hitachi.com> wrote:

>>>If you mount a ext3 fs with data_err=abort option, it aborts on file
>>>data write error.  If you mount it with data_err=ignore, it doesn't
>>>abort, just call printk().  data_err=abort is default, because
>>>people have used this error handling policy for three years.
>>
>>Thanks for making this configurable!
>>
>>But given how surprised many of us were when we found out that
>>jbd/ext3 has been aborting on file data blocks isn't this our chance
>>to correct that long-standing oversight?  Shouldn't the default be
>>data_err=ignore?  Or would changing this behavior cause more harm than
>>good?

I asked Japanese server vendor's people which default is preferred,
and they agreed on data_err=abort.  But it would not be true for
all users all over the world.

>>I don't feel strongly either way, having the "data_err" option makes
>>this issue moot for me, but I figured I'd raise the question (in the
>>interest of review).
> 
> Yes, good point.  I don't think any of the ext3 maintainers were aware
> that the 3-years-old patch had introduced "abort on data error" behaviour.
> The default for ext4 is only now going to errors=remount-ro from
> errors=continue (as it is on ext2/3) so I think it is inconsistent to
> have the journal abort on data errors when the filesystem itself does not.

It's good point.  Well, how about setting the default depending on
"errors" option?  It means the default is data_err=ignore on
errors=continue and data_err=abort on errors=remount-ro/panic.
If it is confusing, I don't mind if the default is simply
data_err=ignore.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

