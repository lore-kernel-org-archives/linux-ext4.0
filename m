From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: [RFC] [PATCH 1/1] Nanosecond timestamps
Date: Thu, 8 Feb 2007 11:33:25 +0100
Message-ID: <20070208103325.GA28900@lombardij>
References: <1170427790.6464.6.camel@garfield> <20070206151242.GB3140@lombardij> <20070207203946.GB6565@schatzie.adilger.int> <1170882340.13329.4.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57144 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965714AbXBHKcu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Feb 2007 05:32:50 -0500
In-Reply-To: <1170882340.13329.4.camel@kleikamp.austin.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 07, 2007 at 03:05:39PM -0600, Dave Kleikamp wrote:
> On Wed, 2007-02-07 at 13:39 -0700, Andreas Dilger wrote:
> > You are right - this works fine on little endian systems, but fails on
> > big endian systems where you will get the other half of the word.
> > 
> > This has been a bug in several places already, and I wonder if the
> > le*_to_cpu() and cpu_to_le*() macros shouldn't do some type checking
> > instead of just casting the variable to the specified type?
> 
> I think that sparse will catch this.  To get the endian checks you need
> to do something like this:
> 
> make C=2 CF="-D__CHECK_ENDIAN__"'

Indeed:

  CHECK   fs/ext3/super.c
  fs/ext3/super.c:1787:8: warning: cast to restricted type
  fs/ext3/super.c:1789:6: warning: cast to restricted type
  fs/ext3/super.c:1791:8: warning: cast to restricted type
  fs/ext3/super.c:1793:6: warning: cast to restricted type

Thanks,
Johann
