From: Ted Ts'o <tytso@mit.edu>
Subject: Re: error ext4_mb_generate_buddy:726 & add_dirent_to_buf:1272
 after online resize
Date: Sat, 29 Jan 2011 17:33:10 -0500
Message-ID: <20110129223310.GD19287@thunk.org>
References: <S1752440Ab1APNtL/20110116134911Z+826@vger.kernel.org>
 <4D32FACD.7020907@pook.it>
 <4D3300A5.1090300@pook.it>
 <4D44919C.6010404@pook.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Stuart Pook <slp4725@pook.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53946 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1A2WdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Jan 2011 17:33:23 -0500
Content-Disposition: inline
In-Reply-To: <4D44919C.6010404@pook.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 29, 2011 at 11:15:56PM +0100, Stuart Pook wrote:
> I am getting these message about once a day. Each message arrives 24 hours amd a few minuted after the last message, wierd.  Inode 262145 is a directory that I created just after the online resize of the filesystem.

Sorry for my lack of response.  I've been in Brisbane for the past
week attending linux.conf.au.  This message which you are seeing:

> /var/log/syslog:Jan 29 17:57:21 kooka kernel: : [1125159.904008] EXT4-fs (dm-28): error count: 11
> /var/log/syslog:Jan 29 17:57:21 kooka kernel: : [1125159.904014] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
> /var/log/syslog:Jan 29 17:57:21 kooka kernel: : [1125159.904017] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578

... is strictly speaking not an error.  It is a status report
indicating that in the past your file system had suffered an error.
The first error was at 1295177566 seconds past the epoch, or at:

% date -d @1295177566
Sun Jan 16 06:32:46 EST 2011

...and the most recent error was at:

% date -d @1295177566
Sun Jan 16 06:32:46 EST 2011

If you upgrade to e2fsck 1.41.14, it will reset the error counter and
the first/last most recent errors.  The idea behind this is that
sometimes people aren't paying close attention to their
/var/log/messages file, so this is a periodic informational reminder,
printed once a day.  If you are creating shell scripts to find errors,
match on "EXT4-fs Error", for example "EXT4-fs error (dm-28): disk on
fire".  Warnings will be denoted with "EXT4-fs warning", and and
information messages, such as this one just start with "EXT4-fs", as
in "EXT4-fs (dm-28): ..."

Hope this helps,

						- Ted
