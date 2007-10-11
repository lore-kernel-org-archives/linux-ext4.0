From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS
	is not set
Date: Thu, 11 Oct 2007 13:00:02 -0700
Message-ID: <1192132802.8308.2.camel@dyn9047017100.beaverton.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>
	 <20071009061101.666614585@au1.ibm.com>
	 <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com>
	 <1191949386.3793.16.camel@localhost.localdomain>
	 <20071009174012.GJ31713@thunk.org> <20071010002203.GL31713@thunk.org>
	 <1192030210.12131.61.camel@dyn9047017100.beaverton.ibm.com>
	 <20071010190035.GR31713@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, markn@au1.ibm.com,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54362 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbXJKT5G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:57:06 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJv0RX008843
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:57:00 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJv0RA428318
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:57:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJuwp5005375
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:57:00 -0600
In-Reply-To: <20071010190035.GR31713@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-10-10 at 15:00 -0400, Theodore Tso wrote:
> On Wed, Oct 10, 2007 at 08:30:10AM -0700, Badari Pulavarty wrote:
> > Its a good start. I think there are lots of proc handling routines that
> > can be move into #ifdef CONFIG_PROC_FS also.
> > 
> > All the code around ext4_mb_read_prealloc_table(),
> > ext4_mb_write_prealloc_table(), MB_PROC_VALUE_READ(stats),
> > MB_PROC_VALUE_WRITE(stats), .. can be ifdefed out.
> 
> There's no need to ifdef them out; in include/proc_fs.h there are the
> following convenience #define's if CONFIG_PROC_FS is not defined:

Sorry. If I wasn't clear.. What I meant to say was the above
routines are NOT needed if we don't define CONFIG_PROC_FS. They
are supporting read/write to /proc files. We can #ifdef them
out to reduce the text size.

Thanks,
Badari
