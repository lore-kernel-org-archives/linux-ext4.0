From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 update for 2.6.39-rc1
Date: Fri, 25 Mar 2011 10:02:48 -0700
Message-ID: <AANLkTi=aKLhtuuMtd=KZ8YBykCp=yJ-KPAJ3jKQq0jQW@mail.gmail.com>
References: <E1Q2wpD-0002It-CE@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673Ab1CYRDr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Mar 2011 13:03:47 -0400
In-Reply-To: <E1Q2wpD-0002It-CE@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 24, 2011 at 7:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Please pull from:
>
> =A0git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_l=
inus
>
> to get the ext4 updates for the 2.6.39 merge window.

Ok, guys, can you verify my merge? In one branch, we had Tejun change
it to use "alloc_workqueue()", and in another, ext4 switched from
create_workqueue() to create_singlethread_workqueue().

My resolution was to use WQ_UNBOUND in allow_workqueue() in the
resulting merge, which I think should be semantically the correct
resolve. But the commit message in the create_singlethread_workqueue()
change seems to imply that the single-threadedness isn't a
_correctness_ issue as much as it is just a "we don't need multiple
threads" issue, so maybe the WQ_UNBOUND isn't necessary. So WQ_UNBOUND
may or may not be a good idea.

Regardless, please give it a look, ok?

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
