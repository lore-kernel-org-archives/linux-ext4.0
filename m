From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] ext3: add an option to control error handling on	file
 data
Date: Wed, 30 Jul 2008 15:17:03 -0600
Message-ID: <20080730211703.GZ3342@webber.adilger.int>
References: <488FD756.9060106@hitachi.com>
 <170fa0d20807300814o7741859eu8ad5d5b3b95e401c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	tglx@linutronix.de, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43281 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbYG3VRR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 17:17:17 -0400
In-reply-to: <170fa0d20807300814o7741859eu8ad5d5b3b95e401c@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 30, 2008  11:14 -0400, Mike Snitzer wrote:
> On Tue, Jul 29, 2008 at 10:52 PM, Hidehiro Kawai
> <hidehiro.kawai.ez@hitachi.com> wrote:
> > If the journal doesn't abort when it gets an IO error in file data
> > blocks, the file data corruption will spread silently.  Because
> > most of applications and commands do buffered writes without fsync(),
> > they don't notice the IO error.  It's scary for mission critical
> > systems.  On the other hand, if the journal aborts whenever it gets
> > an IO error in file data blocks, the system will easily become
> > inoperable.  So this patch introduces a filesystem option to
> > determine whether it aborts the journal or just call printk() when
> > it gets an IO error in file data.
> >
> > If you mount a ext3 fs with data_err=abort option, it aborts on file
> > data write error.  If you mount it with data_err=ignore, it doesn't
> > abort, just call printk().  data_err=abort is default, because
> > people have used this error handling policy for three years.
> 
> Thanks for making this configurable!
> 
> But given how surprised many of us were when we found out that
> jbd/ext3 has been aborting on file data blocks isn't this our chance
> to correct that long-standing oversight?  Shouldn't the default be
> data_err=ignore?  Or would changing this behavior cause more harm than
> good?
> 
> I don't feel strongly either way, having the "data_err" option makes
> this issue moot for me, but I figured I'd raise the question (in the
> interest of review).

Yes, good point.  I don't think any of the ext3 maintainers were aware
that the 3-years-old patch had introduced "abort on data error" behaviour.
The default for ext4 is only now going to errors=remount-ro from
errors=continue (as it is on ext2/3) so I think it is inconsistent to
have the journal abort on data errors when the filesystem itself does not.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

