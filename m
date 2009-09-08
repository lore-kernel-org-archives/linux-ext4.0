From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Tue, 8 Sep 2009 07:57:02 -0700
Message-ID: <6601abe90909080757r23faeabbt7dcdfa3d5daf5985@mail.gmail.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
	 <20090908050614.GA10477@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Frank Mayhar <fmayhar@google.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:3730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZIHO5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 10:57:05 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n88Ev5hH010980
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 07:57:06 -0700
Received: from pxi33 (pxi33.prod.google.com [10.243.27.33])
	by zps75.corp.google.com with ESMTP id n88Ev2IS014330
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 07:57:03 -0700
Received: by pxi33 with SMTP id 33so3294646pxi.11
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2009 07:57:02 -0700 (PDT)
In-Reply-To: <20090908050614.GA10477@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Mon, Sep 7, 2009 at 10:06 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Fri, Sep 04, 2009 at 07:55:00PM -0700, Frank Mayhar wrote:
>> Teach ext4_write_inode() and ext4_do_update_inode() about non-journa=
l
>> mode: =A0If we're not using a journal, ext4_write_inode() now calls
>> ext4_do_update_inode() (after getting the iloc via ext4_get_inode_lo=
c())
>> with a new "do_sync" parameter. =A0If that parameter is nonzero
>> ext4_do_update_inode() calls sync_dirty_buffer() instead of
>> ext4_handle_dirty_metadata().
>
> Hi Frank,
>
> The problem with this patch is that it's only safe to call
> sync_dirty_buffer() if we are not journalling. =A0If we are using the
> journal, we must *not* call sync_dirty_buffer(), but instead must use
> jbd2_journal_dirty_metadata().
>
> The problem is that there are paths where ext4_do_update_inode() can
> get called with do_sync=3D=3D1, even when journalling is enabled.
> Specifically, if ext4_write_inode() is called with wait=3D=3D1, wait =
is
> passed to ext4_do_update_inode() as do_sync, and then when a journal
> is present, we will end up calling sync_dirty_buffer(), which means w=
e
> will be writing out the modified metadata *before* the transaction ha=
s
> committed.
>
> If you try using your patch with journalling enabled, and you try
> doing some power fail testing, my code inspection leads me to believe
> with 99% certainty that the filesystem will be corrupted as a result.
>
> I think what you need to do instead is to add an extra parameter
> do_sync to ext4_handle_dirty_metadata(), and continue to call
> ext4_handle_dirty_metadata. =A0However in code paths where we will la=
ter
> force a commit to guarantee that the metadata has been written out
> (i.e., in the fsync() code path), ext4_handle_dirty_metadata() should
> be called with the new do_sync parameter set to 1.
>
> Does that make sense?

I think we can take a look at this, but there are a lot of calls to
ext4_handle_dirty_metadata(), and it's not clear on a quick inspection
that we'd be able to determine which would need to be called with
do_sync =3D 1...

On the other hand, this would take care of a similar problem that I
was going to be sending a patch for this week: where removing an
extent block without a journal requires a sync_dirty_buffer() in order
to avoid writeback of the extent header in the block, *after* the
block is marked free in the bitmap.

There are probably other cases where, without a journal, an explicit
sync_dirty_buffer() is needed for metadata.  Handling this in
ext4_handle_dirty_metadata() may be the best way to solve this.

Thanks,
Curt

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
