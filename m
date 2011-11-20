From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: group info caches set to SLAB_MEM_SPREAD
 flags.
Date: Sun, 20 Nov 2011 13:38:46 -0500
Message-ID: <20111120183846.GB12868@thunk.org>
References: <1321747359-1919-1-git-send-email-linkinjeon@gmail.com>
 <CAKYAXd_YXUymFjbxgXwV+pXJNvPhq-W_Pi96mU3NodO3yyNTrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33897 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab1KTSit (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Nov 2011 13:38:49 -0500
Content-Disposition: inline
In-Reply-To: <CAKYAXd_YXUymFjbxgXwV+pXJNvPhq-W_Pi96mU3NodO3yyNTrg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 20, 2011 at 02:45:32PM +0900, NamJae Jeon wrote:
> This patch is not really meaningful ? or you need to see performance
> data although cpuset mem spread flags patch is proved before.
> I am waiting for your decision.

I don't think it's really going to make much of a difference, to be
honest.  It's probably technically a little better, but at the end of
the day, it's not really worth the tiny amount of effort to process
the patch.

I put it in the same category as people who like to remove whitespaces
from files or remove unused variables.  It marginally makes the code a
tiny amount better, but at the moment, review bandwidth in the ext4
subsystem is a critically tight resource, and in terms of the grand
scheme of things, there are higher priority things that I need to
worry about, as opposed to people constantly resending trivial patches
and demanding a decision.

So let me ask a counter question --- why are you sending these
patches?  Especially when you don't even have a system that would
benefit from such changes?  Is it just ego to have your name in the
kernel, or to be counted amongst kernel developers?  Is this a warm up
because you'd like to do more substantive work in ext4, or other parts
of the kernel?  Is this a University exercise?  And if you're from a
company, which company, and what's your interest in ext4?  I
understand how Whamcloud uses ext4, and how the Android folks are
using ext4, and to a lesser extent how Tao Bao is using ext4, and that
helps me understand where they are going with ext4 and why they submit
the kind of patches that they do.

But I don't understand why *you* are submitting these sorts of
patches.  If there's substantive work that you plan to do with ext4,
then the investment I might make in helping you become more proficient
ext4 developers is quite different from say, the sort of attention I
might give someone who is working on ext4 for a class project or for
ego reasons.

Best regards,

						- Ted
