From: Avi Kivity <avi@redhat.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Tue, 03 Aug 2010 16:24:49 +0300
Message-ID: <4C5818A1.9070102@redhat.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0HCNY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 09:24:57 -0400
In-Reply-To: <20100630124832.GA1333@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 06/30/2010 03:48 PM, tytso@mit.edu wrote:
>
> I wonder if it's worthwhile to think about a new system call which
> allows users to provide an array of fd's which are collectively should
> be fsync'ed out at the same time.  Otherwise, we end up issuing
> multiple barrier operations in cases where the application needs to
> do:
>
> 	fsync(control_fd);
> 	fsync(data_fd);
>

The system call exists, it's called io_submit().

-- 
error compiling committee.c: too many arguments to function

