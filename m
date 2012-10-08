From: Jan Kara <jack@suse.cz>
Subject: Re: freeze_bdev hangs
Date: Mon, 8 Oct 2012 18:19:26 +0200
Message-ID: <20121008161926.GH9243@quack.suse.cz>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
 <506F19E6.8030005@redhat.com>
 <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab2JHQT2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 12:19:28 -0400
Content-Disposition: inline
In-Reply-To: <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-10-12 13:13:34, Prashant Shah wrote:
> Hi,
> 
> On Fri, Oct 5, 2012 at 11:03 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > I haven't looked at your custom code, but freeze has changed a bit lately,
> > and "hangs" is a very vague description
> >
> > -Eric
> 
> I am monitoring the file system (ext3) for block writes and on
> linux-2.6.18 (centos - 5.8 64bit) there are lots of writes request per
> second with inode number set to 0 even when the file system is idle
> and without any work loads. Didnt see this happen on linux-3.x.
> 
> filter: sector=242983 inode=0
> filter: sector=242991 inode=0
> filter: sector=242999 inode=0
> filter: sector=243007 inode=0
> filter: sector=243015 inode=0
> filter: sector=243023 inode=0
> filter: sector=243031 inode=0
> filter: sector=243039 inode=0
  And what tool are you using for monitoring?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
