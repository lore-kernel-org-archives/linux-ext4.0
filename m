From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 17:03:06 -0500
Message-ID: <482E049A.5020005@redhat.com>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516135814.1c973bd5.akpm@linux-foundation.org> <20080516214516.GA15334@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYEPWDN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 18:03:13 -0400
In-Reply-To: <20080516214516.GA15334@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jamie Lokier wrote:
> Andrew Morton wrote:
>>> I suppose alternately I could send another patch to remove "remember
>>> that ext3/4 by default offers higher data integrity guarantees than
>>> most." from Documentation/filesystems/ext4.txt  ;)
>> We could add a big scary printk at mount time and provide a document?
> 
> Can I suggest making /proc/mounts say "barrier=0" when journal is not
> enabled, instead of omitting the option.
> 
> Boot logs are too large to pay close attention to unless it's really
> obvious.  (2.4 kernels _do_ have a similar message about "data
> integrity not guaranteed" with USB drivers - I never understood what
> it was getting it, and why it was removed for 2.6).
> 
> However, if I saw barrier=0 in /proc/mounts it would at least prompt
> me to look it up and then making an informed decision.

Right now, ext3_show_options has the scheme:

/*
 * Show an option if
 *  - it's set to a non-default value OR
 *  - if the per-sb default is different from the global default
 */

so only non-default is shown, so today barrier=0 is not shown.  I
suppose that could be changed...

FWIW, my patch would show barrier=0 if it's manually mounted that way
(against new proposed defaults), or if we are running w/o barriers due
to a failed barrier IO even though barriers were requested.

> Personally I had assumed barriers were enabled by default with ext3,
> as some distros do that, the 2.4 patches did that, and:
> 
>    I *have* experienced corruption following power loss without
>    barriers, and none with barriers.
> 
>    When I mentioned that turning off write cache or using barriers is
>    a solution to a programmer working on the same project, she said
>    "oh, yes, we've had reports of disk corruption too - thanks for the
>    advice", and the advice worked, so I am not the only one.
> 
>    (In the interests of perspective, that's with ext3 on patched 2.4
>    kernels on a ARM device, but still - the barriers seem to work).
> 
> On a related note, there is advice floating about the net to run with
> IDE write cache turned off if you're running a database and care about
> integrity.  That has much worse performance than barriers.

... and I've seen hand-waving about shortened drive life running this
way?  but who really knows....

Thanks,
-Eric

> I guess the patch which fixes fsync is particularly useful for those
> database users, as it means they can run with write cache enabled and
> depend on fsync() to give equivalent integrity now.  (Enabling
> journalling is not really relevant to this).
> 
> -- Jamie
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

