From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sat, 22 Jan 2011 08:05:58 -0500
Message-ID: <4D3AD636.6040801@gmail.com>
References: <1295568782.2459.29.camel@tybalt> <20110121013140.GA8949@dhcp231-156.rdu.redhat.com> <1295601083.5799.3.camel@tybalt> <20110121125922.GB8949@dhcp231-156.rdu.redhat.com> <20110121140306.GA11313@dhcp231-156.rdu.redhat.com> <1295620109.22802.1.camel@tybalt> <20110121143145.GB11313@dhcp231-156.rdu.redhat.com> <20110121235641.GM3043@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39094 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1AVNGC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jan 2011 08:06:02 -0500
Received: by qyj19 with SMTP id 19so1529855qyj.19
        for <linux-ext4@vger.kernel.org>; Sat, 22 Jan 2011 05:06:01 -0800 (PST)
In-Reply-To: <20110121235641.GM3043@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/21/2011 06:56 PM, Ted Ts'o wrote:
> On Fri, Jan 21, 2011 at 09:31:45AM -0500, Josef Bacik wrote:
>> Yup, whatever you are doing in your webapp is making your database do lots of
>> fsyncs, which is going to suck.  If you are on a battery backed system or just
>> don't care if you lose your database and rather it be faster you can mount your
>> ext4 fs with -o nobarrier.  Thanks,
> Note that if you don't use -o barrier on ext3, or use -o nobarrier on
> ext4, the chance of significant file system damage if you have a power
> failure, since without the barrier, the file system doesn't wait for
> disk to acknowledge that the data has hit the barrier.  The problem is
> that if you are using a barrier operation, you're not going to be able
> to get more than about 30-50 non-trivial[1] fsync's per second on a
> standard HDD; barriers are inherently slow.
>
> [1] Where there was some kind of data write between the two fsync's.
> You may be able to get faster back-to-back fsync() with no intervening
> data writes, but that's not terribly interesting.  :-)
>
> A UPS should protect you against most of the dangers of not using
> barriers.  The other choice is to be more intelligent with your coding
> (and/or with your database choice) to avoid needing a huge number of
> fsync's, as they are going to be costly.  If you can batch multiple
> database operations under a single commit, for example, you should be
> able to eliminate the need for so many fsync's.
>
> 		        	       	       - Ted
>

Just a note that databases usually already think hard about batching updates 
into transactions which all go to disk on a commit.

Various databases have statistics to show the average size of a transaction, etc 
and that can help you tune your workload,

Ric

