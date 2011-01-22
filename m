From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sat, 22 Jan 2011 14:37:19 -0500
Message-ID: <EF21BE9C-2457-4C17-A667-9839E23C58B8@mit.edu>
References: <1295568782.2459.29.camel@tybalt> <20110121013140.GA8949@dhcp231-156.rdu.redhat.com> <1295601083.5799.3.camel@tybalt> <20110121125922.GB8949@dhcp231-156.rdu.redhat.com> <20110121140306.GA11313@dhcp231-156.rdu.redhat.com> <1295620109.22802.1.camel@tybalt> <20110121143145.GB11313@dhcp231-156.rdu.redhat.com> <20110121235641.GM3043@thunk.org> <4D3A2EC6.3020700@shiftmail.org> <20110122013415.GN3043@thunk.org> <4D3B03FA.4040604@shiftmail.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:42969 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab1AVTmY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jan 2011 14:42:24 -0500
In-Reply-To: <4D3B03FA.4040604@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 22, 2011, at 11:21 AM, torn5 wrote:
> 
> I'd have a different question now:
> Is the fsync in a nobarrier mount totally swallowed?

No.   It will still cause a journal commit, and send disk writes down to the HDD.   How those disk writes will be interpreted by the HDD is completely up to the HDD's firmware.   It could seek like mad and try to write all of those disk blocks as they arrive, or it could try to batch writes which are farther away to minimize disk head movement, and perhaps combine writes that arrive potentially seconds or minutes apart. 

> If not:
> a) what guarantees does it provide in a nobarrier situation and

As long as there is not a power failure (or disk failure, of couse), those disk writes will eventually hit the platter.   The data should be consistent on disk if the kernel were to panic, or someone were to hit the reset button.   So you will have at least that level of guarantee.  But if the power cord gets kicked out of the wall, or the floor waxer in the data center causes the circuit breaker to pop, or the flood waters in Queensland start pouring into the underground car park and the transformer locater in said car park shorts out, you have no guarantees at all.

> b) is there a "fakefsync" mount option or some other way to make it a no-op? (I understand the risk, and the fact that this is actually a change in the application's logic)

No, sorry.   Usually the fsync is there for a good reason, and if fsync's are completely eliminated, you have absolutely no guarantees at all.   (Kernel panics, reset buttons, etc., all will cause the database to be totally scrambled.)   Providing such a knob to system administrators who might use it to "speed up" their application, is considered a bit of an attractive nuisance --- short of like providing a button with an LED display that says in bright green friendly colors, "push to test", and then once pushed, changes to an angry red color, "release to detonate".   :-)

You can hack the kernel to do that, though.  Someone who is bright enough to figure out how to create their own fake-fsync mount option is hopefully smart enough to understand the consequences of doing that.  (Just like someone who can figure out how to defeat the safety mechanisms on a lawn mower, and then uses a lawn mower to trim a hedge, is hopefully enough to understand the consequences of what happens if he drops said lawn mower on his foot and loses it.)

The smart, thing, of course, is to write your application logic in a way that doesn't cause so many database transactions.

-- Ted



> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

