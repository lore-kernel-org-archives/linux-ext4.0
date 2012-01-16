From: Jan Kara <jack@suse.cz>
Subject: Re: Filesystem freeze vs blockdevice snapshot
Date: Mon, 16 Jan 2012 20:16:56 +0100
Message-ID: <20120116191656.GB23204@quack.suse.cz>
References: <4F104E2D.3080105@shiftmail.org>
 <CAOQ4uxhTueTHi3UP3AdQo1x1+ONx4Fn8t1F_s9PLZu6arhzN7Q@mail.gmail.com>
 <4F14584B.9080008@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab2APTQ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jan 2012 14:16:59 -0500
Content-Disposition: inline
In-Reply-To: <4F14584B.9080008@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-01-12 18:03:07, Asdo wrote:
> Thanks but it's still not clear to me.
> What do you mean with "clean fs"? is that in any way different from
> an image after a sudden power loss?
  Yes. It is different:
a) the filesystem will be marked as clean so journal will not be replayed
on mount of the snapshot
b) dirty data will be flushed to disk during freezing so you will get most
recent file content. On sudden power failure you might miss quite a lot of
data.

> Secondarily, how can LVM know what filesystem is underneath and call
> the proper freeze? That's a bare block device, there might not even
> be a filesystem under LVM; or it might be exported via iSCSI to an
> XYZ operating system using the Xyzfs filesystem which Linux knows
> nothing about...
  Well, if the kernel has the device mounted, it knows it and it can call
proper fs method to freeze the filesystem. If it is some more complex
scenario (like export to other host), then kernel doesn't know enough and
doesn't attempt to freeze the filesystem.

								Honza

> On 01/14/12 19:33, Amir Goldstein wrote:
> >LVM2 already does the fs freeze for you before taking the snapshot.
> >it's the only way to get a block device snapshot of a "clean" fs.
> >hope that answers your question.
> >
> >On Fri, Jan 13, 2012 at 5:30 PM, Asdo <asdo@shiftmail.org
> ><mailto:asdo@shiftmail.org>> wrote:
> >
> >    Hello all,
> >    please excuse the silly question...
> >
> >    What is the benefit of performing an ext4 fs freeze before taking
> >    a snapshot of the underlying block device with LVM2 ?
> >
> >    Is the freeze step useful or I can go with the snapshot directly?
> >
> >    And/or is there another use case for the freeze?
> >
> >    Thank you
> >    --
> >    To unsubscribe from this list: send the line "unsubscribe
> >    linux-ext4" in
> >    the body of a message to majordomo@vger.kernel.org
> >    <mailto:majordomo@vger.kernel.org>
> >    More majordomo info at http://vger.kernel.org/majordomo-info.html
> >
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
