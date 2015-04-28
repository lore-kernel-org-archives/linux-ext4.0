From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
 small fs
Date: Tue, 28 Apr 2015 14:24:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1504281423330.2386@localhost.localdomain>
References: <1427280382-31120-1-git-send-email-lczerner@redhat.com> <553ABAF0.2020702@redhat.com> <D2BC34F2-AB5D-4923-A2D6-28CEC2807C9A@dilger.ca> <20150427161451.GA22448@quack.suse.cz> <553E6277.3040800@redhat.com> <20150428122102.GA9955@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535AbbD1MYy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2015 08:24:54 -0400
In-Reply-To: <20150428122102.GA9955@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 Apr 2015, Jan Kara wrote:

> Date: Tue, 28 Apr 2015 14:21:02 +0200
> From: Jan Kara <jack@suse.cz>
> To: Eric Sandeen <sandeen@redhat.com>
> Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
>     Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
>     small fs
> 
> On Mon 27-04-15 11:23:19, Eric Sandeen wrote:
> > On 4/27/15 11:14 AM, Jan Kara wrote:
> > > On Fri 24-04-15 22:25:06, Andreas Dilger wrote:
> > >> On Apr 24, 2015, at 3:51 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > >>> On 3/25/15 5:46 AM, Lukas Czerner wrote:
> > >>>> Currently we're unable to online resize very small (smaller than 32 MB)
> > >>>> file systems with 1k block size because there is not enough space in the
> > >>>> journal to put all the reserved gdt blocks.
> > >>>
> > >>> So, I'll get to the patch review if I need to, but this all seemed a little
> > >>> odd; this is a regression, so do we really need to restrict things at mkfs
> > >>> time?
> > >>>
> > >>> On the userspace side, things were ok until:
> > >>>
> > >>> 9f6ba88 resize2fs: add support for new in-kernel online resize ioctl
> > >>>
> > >>> and even with that, on the kernelspace side, things were ok until:
> > >>>
> > >>> 8f7d89f jbd2: transaction reservation support
> > >>>
> > >>> I guess I'm trying to understand why that jbd2 commit regressed this.
> > >>> I've not been paying enough attention to ext4 lately.  ;)
> > >>>
> > >>> I mean, the threshold got chopped in half:
> > >>>
> > >>> -       if (nblocks > journal->j_max_transaction_buffers) {
> > >>> +       /*
> > >>> +        * 1/2 of transaction can be reserved so we can practically handle
> > >>> +        * only 1/2 of maximum transaction size per operation
> > >>> +        */
> > >>> +       if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
> > >>>                printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
> > >>> -                      current->comm, nblocks,
> > >>> -                      journal->j_max_transaction_buffers);
> > >>> +                      current->comm, blocks,
> > >>> +                      journal->j_max_transaction_buffers / 2);
> > >>>                return -ENOSPC;
> > >>>        }
> > >>>
> > >>> so it's clear why the behavior changed, I guess, but it feels like I
> > >>> must be missing something here.
> > >>
> > >> Is there some way to reserve these journal blocks only in the case of
> > >> delalloc usage?  This has caused a performance regression with Lustre
> > >> servers on 3.10 kernels because the journal commits twice as often.
> > >> We've worked around this for now by doubling the journal size, but it
> > >> seems a bit of a hack since we can never use the whole journal anymore.
> > >   Hum, so the above hunk only limits maximum number of credits used by a
> > > single handle. Multiple handles can still consume upto maximum transaction
> > > size buffers (at least that's the intention :). So I don't see how that can
> > > cause the problem you describe.  What can happen though is that there are
> > > quite a few outstanding reserved handles and so we have to reserve space
> > > for them in the running transaction. Do you use dioread_nolock option? That
> > > enables the use of reserved handles in ext4 for conversion of unwritten
> > > extents...
> > 
> > You're probably asking Andreas, but just in case, for my testcase, it's
> > all defaults & standard options.
> > 
> > i.e. just this fails, after the above commit, whereas it worked before.
> > 
> > mkfs.ext4 /dev/sda 20M
> > mount /dev/sda /mnt/test
> > resize2fs /dev/sda 200M
>   Yeah, I understand your failure - transaction reservation has reduced
> max transaction size to a half. After that your fs resize exceeds max
> transaction size and we are in trouble. I'd prefer solution for that to be
> in resize code though because it's really a corner case and I wouldn't like
> to slow down the common transaction start path for it...

Hi Jan,

if you have not already, please see the patch which started the
discussion.

Also I think that aside from the userspace fix, I need to add some
safety to the kernel as well so that people who do run into this
know what's going on.

Thanks!
-Lukas

> 
> 								Honza
> 
