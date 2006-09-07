From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC][PATCH] set_page_buffer_dirty should skip unmapped buffers
Date: Wed, 6 Sep 2006 20:34:42 -0700
Message-ID: <20060906203442.3b28f293.akpm@osdl.org>
References: <Pine.LNX.4.64.0609011652420.24650@hermes-2.csi.cam.ac.uk>
	<1157128342.30578.14.camel@dyn9047017100.beaverton.ibm.com>
	<20060901101801.7845bca2.akpm@osdl.org>
	<1157472702.23501.12.camel@dyn9047017100.beaverton.ibm.com>
	<20060906124719.GA11868@atrey.karlin.mff.cuni.cz>
	<1157555559.23501.25.camel@dyn9047017100.beaverton.ibm.com>
	<20060906153449.GC18281@atrey.karlin.mff.cuni.cz>
	<1157559545.23501.30.camel@dyn9047017100.beaverton.ibm.com>
	<20060906162723.GA14345@atrey.karlin.mff.cuni.cz>
	<1157563016.23501.39.camel@dyn9047017100.beaverton.ibm.com>
	<20060906172733.GC14345@atrey.karlin.mff.cuni.cz>
	<20060906191430.7ffcd833.akpm@osdl.org>
	<44FF8C3B.3040505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Anton Altaparmakov <aia21@cam.ac.uk>,
	sct@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:18887 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1422690AbWIGDfq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Sep 2006 23:35:46 -0400
To: Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <44FF8C3B.3040505@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 06 Sep 2006 20:04:27 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> > I've been unable to reproduce this crash, btw.  Is there some magic
> > incantation apat from running `fsx-linux'?
> >   
> All I do is on a single 1k filesystem, run 4 copies of fsx (on 4 
> different files, ofcourse).
> I hit the assert anywhere between 10min-2hours.

hm, OK.

It could be that running

	while (1) {
		write(fd, "", 1);
		fsync(fd);
	}

will speed it up: cause a storm of commits, increase the probability.
