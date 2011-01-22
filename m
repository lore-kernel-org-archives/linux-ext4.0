From: torn5 <torn5@shiftmail.org>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sat, 22 Jan 2011 17:21:14 +0100
Message-ID: <4D3B03FA.4040604@shiftmail.org>
References: <1295568782.2459.29.camel@tybalt>
 <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
 <1295601083.5799.3.camel@tybalt>
 <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org> <4D3A2EC6.3020700@shiftmail.org>
 <20110122013415.GN3043@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: torn5 <torn5@shiftmail.org>, Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.isti.cnr.it ([194.119.192.4]:4671 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1AVQWM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jan 2011 11:22:12 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWXKB546QOOMKASW@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sat, 22 Jan 2011 17:21:24 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWXKB3D1VKOMKAT7@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sat, 22 Jan 2011 17:21:22 +0100 (MET)
In-reply-to: <20110122013415.GN3043@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/22/2011 02:34 AM, Ted Ts'o wrote:
> ....
>
> At the end of the day, though, if the application protocol design is
> stupid, there's not much you can do.
> ....

Thanks for your reply.
You are right, now I'm starting to understand that what I was trying to 
achieve was actually a change in the application logic...

I'd have a different question now:
Is the fsync in a nobarrier mount totally swallowed?
If not:
a) what guarantees does it provide in a nobarrier situation and
b) is there a "fakefsync" mount option or some other way to make it a 
no-op? (I understand the risk, and the fact that this is actually a 
change in the application's logic)
