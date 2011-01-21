From: Josef Bacik <josef@redhat.com>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Thu, 20 Jan 2011 20:31:40 -0500
Message-ID: <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
References: <1295568782.2459.29.camel@tybalt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jon Leighton <j@jonathanleighton.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1AUBf0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jan 2011 20:35:26 -0500
Content-Disposition: inline
In-Reply-To: <1295568782.2459.29.camel@tybalt>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 12:13:02AM +0000, Jon Leighton wrote:
> Hi there,
> 
> I have been experiencing some slowness with an ext4 filesystem. I will
> try to explain and hopefully somebody can identify whether this is
> "normal" or not. Sorry if I am in any sense unscientific - filesystems
> are somewhere near the edge of my computer science knowledge :)
> 
> Basically I am involved with doing some development on the Ruby on Rails
> web app framework, and the automated tests for one component (Active
> Record) does a lot of reading/writing from a database.
> 
> I realised that the test suite was running significantly slower for me
> than for another developer, so I started to investigate. First I created
> an unencrypted partition and put my databases on it, as I had previously
> had everything encrypted.
> 
> This made it somewhat faster, but not massively.
> 
> I then used iotop to see what was going on when I ran the tests. I
> discovered that the process jbd2/sda3-8 was doing *lots* of IO when I
> run these tests.
> 
> I did some googling and tried a few things. Removing the journal solved
> the problem (as would be expected, I guess), but also recreating the
> partition as ext3 rather than ext4 solved it too (which perhaps
> indicates a regression?) When I say 'solved', I mean it took a single
> run of this particular test suite from say 4.5 minutes to more like
> 60-80 seconds.
> 
> I found some other people reporting a similar problem:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/607560
> 
> They complain of the jbd2 process running every few seconds. This is
> something I had not noticed before, but I can observe this on my system
> too. It runs and uses a lot of IO for a short period of time maybe every
> 2 seconds. So I think I am experiencing the same problem.
> 
> FWIW, using the noatime option does not help at all. Also, I have tried
> using a very recent kernel build with no success. And I have run iotop
> on another laptop (which also has an ext4 partition) and I cannot
> observe this frequent running of jbd2.
> 
> So: does this sound like a bug, and if so, what can be done? I'm very
> happy to provide any additional information as needed.
> 

What kind of database is this?  Does it use lots of files?  When it's being
particularly slow could you run

echo w > /proc/sysrq-trigger

a couple of times, spread out.  This will give us an idea of what everybody is
doing when things are going slow.  Thanks,

Josef

