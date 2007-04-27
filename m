From: Manoj Joseph <manoj@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 18:09:26 +0530
Message-ID: <4631EEFE.7060309@clusterfs.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>	 <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Marat Buharov <marat.buharov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42266 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbXD0Mjc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 08:39:32 -0400
In-Reply-To: <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Marat Buharov wrote:
> On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Aside: why the heck do applications think that their data is so important
>> that they need to fsync it all the time.  I used to run a kernel on my
>> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
>> pleasurable.
> 
> So, if having fake fsync() and fdatasync() is pleasurable for laptop
> and desktop, may be it's time to add option into Kconfig which
> disables normal fsync behaviour in favor of robust desktop?

Sure, a noop fsync/fdatasync would speed up some things. And I am sure 
Andrew Morton knew what he was doing and the consequences.

But unless you care nothing about your data, you should not do it. It is 
as simple as that. No, it does not give you a robust desktop!!

-Manoj

-- 
Manoj Joseph
http://kerneljunkie.blogspot.com/
