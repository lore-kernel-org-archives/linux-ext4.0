From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Mon, 2 May 2016 10:53:25 -0700
Message-ID: <CAPcyv4jfUVXoge5D+cBY1Ph=t60165sp6sF_QFZUbFv+cNcdHg@mail.gmail.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard>
	<1461628381.1421.24.camel@intel.com>
	<20160426004155.GF18496@dastard>
	<x49pot4ebeb.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave Chinner <david@fromorbit.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"axboe@fb.com" <axboe@fb.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"jack@suse.cz" <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34073 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbcEBRx0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2016 13:53:26 -0400
Received: by mail-oi0-f53.google.com with SMTP id k142so199971001oib.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2016 10:53:26 -0700 (PDT)
In-Reply-To: <x49pot4ebeb.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 2, 2016 at 8:18 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Chinner <david@fromorbit.com> writes:
[..]
>> We need some form of redundancy and correction in the PMEM stack to
>> prevent single sector errors from taking down services until an
>> administrator can correct the problem. I'm trying to understand
>> where this is supposed to fit into the picture - at this point I
>> really don't think userspace applications are going to be able to do
>> this reliably....
>
> Not all storage is configured into a RAID volume, and in some instances,
> the application is better positioned to recover the data (gluster/ceph,
> for example).  It really comes down to whether applications or libraries
> will want to implement redundancy themselves in order to get a bump in
> performance by not going through the kernel.  And I think I know what
> your opinion is on that front.  :-)
>
> Speaking of which, did you see the numbers Dan shared at LSF on how much
> overhead there is in calling into the kernel for syncing?  Dan, can/did
> you publish that spreadsheet somewhere?

Here it is:

https://docs.google.com/spreadsheets/d/1pwr9psy6vtB9DOsc2bUdXevJRz5Guf6laZ4DaZlkhoo/edit?usp=sharing

On the "Filtered" tab I have some of the comparisons where:

noop => don't call msync and don't flush caches in userspace

persist => cache flushing only in userspace and only on individual cache lines

persist_4k => cache flushing only in userspace, but flushing is
performed in 4K aligned units

msync => same granularity flushing as the 'persist' case, but the
kernel internally promotes this to a 4K sized / aligned flush

msync_0 => synthetic case where msync() returns immediately and does
no other work

The takeaway is that msync() is 9-10x slower than userspace cache management.

Let me know if there are any questions and I can add an NVML developer
to this thread...
