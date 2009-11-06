From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 06 Nov 2009 08:39:33 -0600
Message-ID: <4AF43525.1040205@redhat.com>
References: <4AF3F82D.50105@elector.dk> <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com> <4AF40D60.1080503@elector.dk> <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com> <20091106140415.GA26342@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexey Salmin <alexey.salmin@gmail.com>,
	Jesper Jensen <linux-ext4_mailinglist@elector.dk>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbZKFOjn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 09:39:43 -0500
In-Reply-To: <20091106140415.GA26342@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Nov 06, 2009 at 05:57:14PM +0600, Alexey Salmin wrote:
>> I think the only thing I can recommend to you is to "grep for your
>> files and hope for the best" (c)
>> I don't know any automated way to restore files after complete
>> destroying of fs, but there always is grep and hexdump :)
> 
> Unfortunately, there isn't much else that can be done, since the inode
> table has been zero'ed out.
> 
> Sorry.  :-(
> 
> 						- Ted

Well, if you repartitioned / moved the partition, then the new mkfs 
likely wouldn't have perfectly overwritten the old metadata structures, 
so if you can re-partition again and put the starting sector -back- at 
the original location, an e2fsck might have a fighting chance to find 
-something- ...

-Eric
