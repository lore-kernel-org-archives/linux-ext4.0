From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Wed, 7 May 2014 18:03:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405071803190.29558@localhost.localdomain>
References: <1399464274-16310-1-git-send-email-lczerner@redhat.com> <20140507143646.GB28814@thunk.org> <alpine.LFD.2.00.1405071714470.2128@localhost.localdomain> <20140507160152.GA6408@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1367954310-1399478613=:29558"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934252AbaEGQDg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 12:03:36 -0400
In-Reply-To: <20140507160152.GA6408@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1367954310-1399478613=:29558
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 7 May 2014, Theodore Ts'o wrote:

> Date: Wed, 7 May 2014 12:01:52 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH v2] ext4: add sysfs entry showing whether the fs contains
>     errors
> 
> On Wed, May 07, 2014 at 05:35:54PM +0200, Lukáš Czerner wrote:
> > 
> > I tried to find sysfs guidelines but I can not see any in
> > Documentation speaking about the contents of the files.
> > 
> > What are the guidelines then ?
> 
> Documentation/filesystems/sysfs.txt:
> 
>    Attributes can be exported for kobjects in the form of regular
>    files in the filesystem. Sysfs forwards file I/O operations to
>    methods defined for the attributes, providing a means to read and
>    write kernel attributes.
> 
>    Attributes should be ASCII text files, preferably with only one value
>    per file. It is noted that it may not be efficient to contain only one
>    value per file, so it is socially acceptable to express an array of
>    values of the same type. 
> 
> I don't remember that last sentence; it was apparently added since the
> last time I've looked at it.  Originally, the requirement that each
> sysfs file (which was supposed to be an kobject attribute) was
> required to be a single value.  Now there's an escape hatch for
> "efficiency", which is nice....

Perfect, thanks!
-Lukas

> 
> > So you're suggesting to have three sysfs files ?
> > 
> > errors_count
> > first_error_time
> > last_error_time
> 
> Yes, that's what I was suggesting.
> 
> 						- Ted
> 
--8323328-1367954310-1399478613=:29558--
