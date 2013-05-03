From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 2nd Attempt - FSCK Errors
Date: Fri, 3 May 2013 11:29:14 -0400
Message-ID: <20130503152914.GE32297@thunk.org>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com>
 <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca>
 <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com>
 <20130503131421.GC32297@thunk.org>
 <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Andreas Dilger' <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Stephen Elliott <techweb@ntlworld.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46162 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112Ab3ECSFo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 May 2013 14:05:44 -0400
Content-Disposition: inline
In-Reply-To: <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 03, 2013 at 02:31:41PM +0100, Stephen Elliott wrote:
> Well... Funny enough, the device which I ran debugfs on was the other
> ReadyNAS device, not the one with the issue anyway. I wanted to test it
> first.

Was the inode number from the other device as well?  Sorry, this is
the first I've heard that there are two ReadyNAS devices in play.
It's one of the reasons why it's really painful to try to be a help
desk for these sorts of questions over e-mail....

> I suspect the underlying architecture supporting RAID in these devices
> screws with the debugfs interface.

Debugfs uses the standard Linux block device interface.  If that's not
sane, e2fsck isn't going to be sane either, and it's a kernel bug.  At
that point, you'll have to talk to ReadyNAS folks since they are
providing the kernel you are using (or the wonky non-standard
hardware, or both....)

> I just find it bizarre that I get the same message regarding multiply
> assigned blocks in 0 files on every FSCK as in it never gets resolved.
> But... No issues with file access or no bad logs etc. I do have a case open
> with Netgear support, since this is basically an appliance.

There have been NAS boxes out there which have used non-standard, out
of tree kernel patches that have resulted in their devices using
non-standard file system formats.  So that's yet another thing which
can't be ruled out...

						- Ted
