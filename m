From: Andreas Dilger <adilger@sun.com>
Subject: Re: Help to edit inode content
Date: Tue, 12 May 2009 14:03:10 -0600
Message-ID: <20090512200310.GP3209@webber.adilger.int>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
 <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
 <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: ranjith kannikara <ranjithkannikara@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56526 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZELUDe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 16:03:34 -0400
Content-disposition: inline
In-reply-to: <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 12, 2009  21:32 +0530, ranjith kannikara wrote:
> On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> > On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
> > <ranjithkannikara@gmail.com> wrote:
> >> I am a computer science engineering student. We have started a project
> >> to make an application to recover deleted files from an ext3
> >> filesystem. For that we have a doubt . Can we edit the inode content?
> >> ie the recovery will be robust if we could edit the inode contents and
> >> give the pointer address manually or through a code. The inode is
> >> being created in the kernel mode and is it possible to edit those
> >> contents if the code is allowed to have the kernel mode permissions..?
>
> But we would like to know whether it is possible to edit the inode
> because it will make the recovery easy and robust. ie he know the
> details of the inode of the file which had been deleted is it possible
> to edit the content of that inode with the pointers of the deleted
> file.?

Are you asking whether it is possible to modify the on-disk structure
of the ext3 inode?  Generally that is NOT allowed because it will of
course break all existing filesystems if not done with extreme care.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

