From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] 285: Fix file syncing
Date: Thu, 30 May 2013 21:57:23 +0200
Message-ID: <20130530195723.GB586@quack.suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
 <1369917939-22660-2-git-send-email-jack@suse.cz>
 <51A75872.4080909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab3E3T5Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 15:57:25 -0400
Content-Disposition: inline
In-Reply-To: <51A75872.4080909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 30-05-13 08:47:30, Eric Sandeen wrote:
> On 5/30/13 7:45 AM, Jan Kara wrote:
> > The intention of tests 08 and 09 in test generic/285 is to sync the
> > whole file before checking for data and holes. However the helper is
> > called with nbytes argument set to 0 which results in not syncing
> > anything. Set nbytes properly.
> 
> Hm, are you sure? (Is the man page wrong, or is the sync_file_range
> implementation wrong?)
> 
> DESCRIPTION
>        sync_file_range()  permits  fine  control when synchronizing the
>        open file referred to by the file descriptor fd with disk.
> 
>        offset is the starting byte of the file  range  to  be  synchro-
>        nized.   nbytes specifies the length of the range to be synchro-
>        nized, in bytes; if nbytes is zero, then all bytes  from  offset
>        through to the end of file are synchronized.
  My fault that I didn't read the manpage carefully enough. Scratch this
patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
