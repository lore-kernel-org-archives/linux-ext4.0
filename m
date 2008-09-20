From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC PATCH] Filesystem Journal Notifications
Date: Sat, 20 Sep 2008 16:51:42 +0100
Message-ID: <20080920155142.GC6061@shareable.org>
References: <20080912220649.GB26999@apaithan-desktop.sanmateo.corp.akamai.com> <20080915023126.GF4090@webber.adilger.int> <20080915053937.GG4090@webber.adilger.int> <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com> <20080915233740.GF3241@webber.adilger.int> <20080916230552.GB13446@apaithan-desktop.sanmateo.corp.akamai.com> <20080919203402.GI10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Abhijit Paithankar <apaithan@akamai.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Joel Becker <joel.becker@oracle.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:40324 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYITPvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 11:51:47 -0400
Content-Disposition: inline
In-Reply-To: <20080919203402.GI10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> That assumes agreement between the applications that are using this
> interface.  It isn't at all desirable that applications have to know
> the "mountpoint" of the filesystem in order to use inotify, and in
> some cases (e.g. bind mount in a new namespace) there isn't even access
> to the root inode.

A filesystem's root inode needn't be mounted at all.

You don't need a new namespace - bind mount is enough by itself.

It has me wondering - how can an application even tell when it has the
root inode of a filesystem?  You can't tell from /etc/mtab or
/proc/mounts, nor from traversing the filesystem itself - except for
filesystems where you know the expected inode number of the root inode.

-- Jamie
