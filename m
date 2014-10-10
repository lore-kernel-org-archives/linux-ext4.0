From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Does the filesystem alter file permissions?
Date: Fri, 10 Oct 2014 16:35:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1410101628080.1539-100000@iolanthe.rowland.org>
References: <E8F54846-9AFE-4980-B90B-6C47E3D28D75@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Ts'o <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35117 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751498AbaJJUfS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2014 16:35:18 -0400
In-Reply-To: <E8F54846-9AFE-4980-B90B-6C47E3D28D75@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 10 Oct 2014, Andreas Dilger wrote:

> On Oct 10, 2014, at 1:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > I'm getting very weird results when creating new files on ext4 
> > filesystems (this is on a CentOS 7 system).  The permissions are not 
> > what they should be.
> > 
> > On the / filesystem, as superuser:
> > 
> > [root@server ~]# umask
> > 0000
> > [root@server ~]# touch a
> > [root@server ~]# ls -l a
> > -r--r----- 1 root root 0 Oct 10 11:45 a
> > 
> > As a normal user:
> > 
> > [stern@server ~]$ umask
> > 0000
> > [stern@server ~]$ touch b
> > [stern@server ~]$ ls -l b
> > -rw------- 1 stern stern 0 Oct 10 11:47 b
> 
> Do you have a default ACL set on the filesystem?  Try "getfacl".

I didn't create any, but it's possible the system installation did.
getfacl /root yields:

# file: root
# owner: root
# group: root
user::r-x
group::r-x
other::---
default:user::r-x
default:group::r-x
default:other::---

getfacl /boot yields:

# file: boot
# owner: root
# group: root
user::r-x
group::r-x
other::r-x
default:user::r-x
default:group::r-x
default:other::r-x

Would this cause the observed effect?  I don't know what the default 
ACLs do.  Are they explained anywhere?

Alan Stern

