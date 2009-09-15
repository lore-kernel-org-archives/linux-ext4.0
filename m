From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] add a message in mount/remount/umount for
 ext2/ext3/ext4
Date: Tue, 15 Sep 2009 15:20:44 -0700
Message-ID: <20090915152044.2e4b941f.akpm@linux-foundation.org>
References: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sct@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbZIOWU6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Sep 2009 18:20:58 -0400
In-Reply-To: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 15 Sep 2009 15:20:39 +0900
Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> Hi Ted, Andrew and all.
> 
> Under the current implementation, we cannot know in the system log 
> (/var/log/messages) when the filesystem (ext2/ext3/ext4) is unmounted.
> For enterprise users, they often want to observe certain filesystems'
> actions (mount/unmount) in the system log. Besides, by the system log, 
> we occasionally wants to know whether a certain filesystem has been
> unmounted or not at the time when a problem happens.
> 

I don't think we want to make random printks a part of the kernel
ABI like this.

I understand that it's practical and easy for people to parse the logs
in a local ad-hoc manner such as this, but...  ugh.

If there's a userspace requirement for notification when filesystems
are mounted and unmounted then fine, let's look at that.  What is the
detailed requirement?  What info do we want to see?  What is an
appropriate way of delivering that info?  kobject_uevent() looks like a
suitable place to start.


That being said, there is perhaps a case to made for being more verbose
when filesystems are mounted and unmounted.  But yes, doing that in the
VFS for all filesystems sounds better.  This might upset people who
have thousands of NFS autmounts though.
